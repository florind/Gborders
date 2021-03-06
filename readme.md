Gborders: Generating a borders overlay in Google Maps
=============

This project is based on the  work I have done here http://blog.newsplore.com/2009/02/22/spincloud-labs-political-boundaries-overlay-in-google-maps-part-1 and here http://blog.newsplore.com/2009/03/01/political-boundaries-overlay-google-maps-2 for adding a live border overlay on Google Maps. See the results in action in http://spincloud.com as you browse the Meteoalarm layer (http://blog.newsplore.com/?p=382)


Prerequisites
=============

* ruby 1.8
* rubygems
* ogr2ogr (part of the gdal package http://www.gdal.org/)
* Your Google Maps v2.0. 

Example
=============

	./make-borders.sh 150
	
generates the country borders for Europe

Example showing the live border layer for Spain: http://blog.newsplore.com/wp-content/uploads/2009/03/embedmap.html

How does it work
=============

The provided shell script downloads a borders file from  http://thematicmapping.org/, converts it into a sqlite db file then a ruby script processes this database to extract the border polygons and generates a JavaScript file ready to embed in your Google Maps page.

Add the resulted JS file in your html:

		 <script type="text/javascript" src="bordersOverlay.js"></script>

then call these two functions in your JS code after initializing the GMap2 object:

		initBorders();
		addBordersOverlay();

A live example is shown here: http://blog.newsplore.com/wp-content/uploads/2009/03/embedmap.html

Performance
=============

Given that there is a large number of polygon points, using all of them to render the borders incurrs a performance penalty on the browser. To address this I devised a simple "straight point reduction" technique that reduces the total number of polygon points and increases the performance when rendering the borders. See http://blog.newsplore.com/2009/03/01/political-boundaries-overlay-google-maps-2 for a detailed explanation. 

Limitations
=============

Currently the generator is limited to whole regions and not individual countries. It is not difficult to add this option if needed, the Ruby script uses a single SQL query for the border selection.

The overlay color is fixed to translucent black and not externalized.

The overlay works with GMap2 API. Ivesvdf has contributed with a generator for V3 here https://gist.github.com/1124959
