/*Google Maps*/
function initialize() {
    var map = new google.maps.Map(document.getElementById('map'),
        mapOptions);
    var featureOpts = [ 
      {
        "stylers": [
          { "invert_lightness": true },
          { "visibility": "simplified" },
          { "saturation": -60 },
          { "lightness": 14 },
          { "gamma": 0.6 },
          { "hue": "#3300ff" }
        ]
      },{
        "stylers": [
          { "hue": "#1900ff" }
        ]
      }
    ]



    var styledMap = new google.maps.StyledMapType(featureOpts,{name: "Styled Map"});

    var mapOptions = {
        zoom: 15,
        center: new google.maps.LatLng(55.832136, 37.6515513),
        disableDefaultUI: true,
        scrollwheel: false,
        zoomControl: true,
        zoomControlOptions: {
            style: google.maps.ZoomControlStyle.SMALL,
            position: google.maps.ControlPosition.RIGHT_CENTER
        },
        mapTypeControlOptions: {
            mapTypeIds: [google.maps.MapTypeId.ROADMAP, 'map_style']
        }
    };
    var map = new google.maps.Map(document.getElementById('map'),
        mapOptions);


    var Marker = new google.maps.Marker({
        position: new google.maps.LatLng(55.832136, 37.6515513),
        map: map,
        icon: {
            url: 'assets/marker.png',
            size: new google.maps.Size(67,98),
            origin: new google.maps.Point(0,0),
            anchor: new google.maps.Point(35, 95)
        }
    });
    map.mapTypes.set('map_style', styledMap);
    map.setMapTypeId('map_style');

}

google.maps.event.addDomListener(window, 'load', initialize);