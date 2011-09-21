mkdir borders
cd borders
wget http://mappinghacks.com/data/TM_WORLD_BORDERS-0.2.zip
mkdir boundaries_shp
unzip TM_WORLD_BORDERS-0.2.zip -d boundaries_shp
wget http://kartoweb.itc.nl/RIMapper/code/shp2mysql_0_4.zip
unzip shp2mysql_0_4.zip -d shp2mysql_04
wget http://dl.maptools.org/dl/shapelib/shapelib_1_2_10.zip
unzip shapelib_1_2_10.zip
cd shapelib-1.2.10
make
cd ..
rm ./shp2mysql_04/src/*.o
sed 's/^OBJS.*$/OBJS = \.\.\/\.\.\/shapelib-1\.2\.10\/shpopen\.o \.\.\/\.\.\/shapelib-1\.2\.10\/dbfopen\.o/' shp2mysql_04/src/Makefile > shp2mysql_04/src/Makefile2
mv shp2mysql_04/src/Makefile2 shp2mysql_04/src/Makefile
cd shp2mysql_04/src
make
cd ../../
cp shp2mysql_04/src/shp2mysql .
./shp2mysql -d boundaries_shp/TM_WORLD_BORDERS-0.2.shp world_boundaries test_db > wb_dump.sql
rm *.zip
rm -rf shp2mysql_04
rm -rf shapelib-1.2.10
rm -rf boundaries_shp
