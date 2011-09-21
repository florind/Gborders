if [ $# == 0 ]; then
	echo "Usage: make-borders {regionId}"
	echo "Region identifiers:"
	echo " 002 Africa"
	echo " 019 Americas"
	echo " 142 Asia"
	echo " 150 Europe"
	echo " 009 Oceania"
  exit 1
fi

echo "Verifying local requirements"
hash ruby 2>&- || { echo >&2 "ruby is required but is not installed.  Aborted.."; exit 1; }
hash gem 2>&- || { echo >&2 "gem is required but is not installed.  Aborted.."; exit 1; }
hash ogr2ogr 2>&- || { 
	echo >&2 "ogr2ogr is required but is not installed."
	echo " Install gdal:" 
	echo " linux: sudo apt-get install gdal-bin"
	echo " mac: brew install geos --use-gcc; brew install gdal"
	echo " Aborting."
	exit 1; 
}

if [ -z "`gem list|grep GeoRuby`" ]; then
	echo "installing GeoRuby gem"
	gem install GeoRuby
fi
if [ -z "`gem list|grep sqlite3`" ]; then
	echo "installing sqlite3 gem"
	gem install sqlite3
fi

echo "Building..."

OUTPUT_DBFILE=world_boundaries.db
OUTPUT_JSFILE=bordersOverlay.js
rm -f $OUTPUT_JSFILE
mkdir borders
cd borders

if [ -s TM_WORLD_BORDERS-0.3.zip ]; then
	echo "skip downloading borders, file exists"
else
	curl -O http://thematicmapping.org/downloads/TM_WORLD_BORDERS-0.3.zip
fi
unzip TM_WORLD_BORDERS-0.3.zip -d boundaries_shp
cd ..

ogr2ogr -f "SQLite" $OUTPUT_DBFILE borders/boundaries_shp/TM_WORLD_BORDERS-0.3.shp -nln world_boundaries -lco FORMAT=WKT -nlt MULTIPOLYGON

ruby gen-borders.rb $OUTPUT_DBFILE $1_$OUTPUT_JSFILE $1
rm -rf *.zip
rm *.db
