var ExifImage = require('exif').ExifImage;
var geolib = require('geolib');

    
try {
    new ExifImage({ image : 'IMG_3295.JPG' }, function (error, exifData) {
        if (error)
            console.log('Error: '+error.message);
        else{
        	var sexagesimalLat = exifData.gps.GPSLatitude[0] + "° " + exifData.gps.GPSLatitude[1] +"' " + exifData.gps.GPSLatitude[2] + "\" " + exifData.gps.GPSLatitudeRef;
        	var sexagesimalLng = exifData.gps.GPSLongitude[0] + "° " + exifData.gps.GPSLongitude[1] +"' " + exifData.gps.GPSLongitude[2] + "\" " + exifData.gps.GPSLongitudeRef;
        	var lat = geolib.sexagesimal2decimal(sexagesimalLat);
        	var lng = geolib.sexagesimal2decimal(sexagesimalLng);
            console.log(lat + "," + lng); // Do something with your data! 
            console.log("39.955846, -75.182942");
            console.log(exifData.gps); 
        }
    });
} catch (error) {
    console.log('Error: ' + error.message);
}