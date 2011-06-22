jQuery ($)->
  geolocation = navigator.geolocation
  move = (lat, lng, zoom) ->
    options = {mapTypeId: google.maps.MapTypeId.ROADMAP, mapTypeControl: false,  streetViewControl: false}
    options['zoom'] = if zoom then zoom else 14
    options['center'] = new google.maps.LatLng(lat, lng)
    map = new google.maps.Map($("#map").get(0), options)

  if location.pathname == '/'
    geolocation.getCurrentPosition (position) ->
      latlng = position.coords
      move(latlng.latitude, latlng.longitude)
