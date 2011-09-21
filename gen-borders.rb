require 'rubygems'
require 'sqlite3'
require 'geo_ruby'

include GeoRuby::SimpleFeatures

def generate_js_border_overlay(db_file, output_file, region)
  factory = GeometryFactory.new
  wkt_parser = EWKTParser.new(factory)

  borderDB = SQLite3::Database::new(db_file)


  res = borderDB.query("select name, iso2, WKT_GEOMETRY, region from world_boundaries where region=" + region)
  encoded_polygon_desc = "";
  remove_warnings_layer = "function removeBordersOverlay() {\n"
  add_warnings_layer = "function addBordersOverlay() {\n"
  init_borders = "function initBorders() {\n"
  res.each do |row|
    name, iso2, multi_polygon, region = *row
    processed_polygon = wkt_parser.parse(multi_polygon);
    encoded_polygon_desc << "var encodedPolygon_#{iso2};\n"
    add_warnings_layer << "map.addOverlay(encodedPolygon_#{iso2});\n"
    remove_warnings_layer << "map.removeOverlay(encodedPolygon_#{iso2});\n"
    init_borders << "encodedPolygon_#{iso2} = \
      new GPolygon.fromEncoded({\n\
      polylines: ["
    factory.geometry.each do |landmass|
      landmass.rings.each do |ring|
        encoded = encode_by_reducing_pointcount(ring.points)
        init_borders << "{color: \"black\",\n\
        weight: 5,\n\
        points: '"
        init_borders << encoded[0].gsub(/\\/, '\&\&') + "',\n\
        levels: '#{encoded[1]}',\n\
        zoomFactor: 2,\n numLevels: 2}"
        init_borders << "," unless ring == landmass.rings.last && landmass == factory.geometry.last
        init_borders << "\n"
      end
    end
    init_borders << "],\nfill:true,\n\
    opacity:0.7,\n\
    color: '#2956B2'\n\
    });"
  end


  add_warnings_layer << "\n}"
  remove_warnings_layer << "\n}"
  init_borders << "\n}"
  File.open(output_file, 'w') {|f|

    f.write(encoded_polygon_desc + "\n")
    f.write(add_warnings_layer + "\n")
    f.write(remove_warnings_layer + "\n")
    f.write(init_borders)
  }
	puts "Success. Check the generated JavaScript file " + output_file
end

def encode_by_reducing_pointcount(points)
  dlat = plng = plat = dlng = 0
  res = ["",""]
  index = -1
  for point in points
    index += 1
    #straight point reduction algorithm: use every 5th point only
    #use all points if their total count is less than 16
    next if index.modulo(5) != 0 && points.size > 16
    late5 = (point.y * 1e5).floor
    lnge5 = (point.x * 1e5).floor
    dlat = late5 - plat;
    dlng = lnge5 - plng;
    plat = late5;
    plng = lnge5;
    res[0] << encode_signed_number(dlat)
    res[0] << encode_signed_number(dlng)
    res[1] << encode_number(3)
  end
  return res
end

def encode_signed_number(num)
  sig_num = num << 1
  sig_num = ~sig_num if sig_num < 0
  encode_number(sig_num)
end

def encode_number(num)
  res = ""
  while num  >= 0x20 do
    res << ((0x20 | (num & 0x1f)) + 63).chr
    num >>= 5
  end
  res << (num + 63).chr
  return res
end

generate_js_border_overlay(ARGV[0], ARGV[1], ARGV[2])

