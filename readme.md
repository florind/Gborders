Gborders: Generating a borders overlay in Google Maps
=============

This project is based on the  work I have done here http://blog.newsplore.com/2009/02/22/spincloud-labs-political-boundaries-overlay-in-google-maps-part-1 and here http://blog.newsplore.com/2009/03/01/political-boundaries-overlay-google-maps-2 for adding a live border overlay on Google Maps. iSee the results in action in http://spincloud.com as you browse the Meteoalarm layer (http://blog.newsplore.com/?p=382)


Prerequisites
=============

* ruby 1.8
* rubygems
* ogr2ogr (part of the gdal package http://www.gdal.org/)

How does it work
=============

The provided shell script downloads a borders file from  http://thematicmapping.org/, converts it into a sqlite db file then a ruby script processes this database to extract the border polygons and generates a JavaScript.

Add the resulted JS file in your html:

		 <script type="text/javascript" src="bordersOverlay.js"></script>

then call these two functions in your JS code after initializing the GMap2 object:

		initBorders();
		addBordersOverlay();

A live example is shown here: http://blog.newsplore.com/wp-content/uploads/2009/03/embedmap.html


Limitations
=============

Currently the generator is limited to whole regions and not individual countries. It is not difficult to add this option if needed, the Ruby script uses a single SQL query for the border selection.

The overlay color is fixed to translucent black and not externalized.
