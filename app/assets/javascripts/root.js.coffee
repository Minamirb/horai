jQuery ($)->
  geolocation = navigator.geolocation
  map = false
  if location.pathname == '/'
    geolocation.getCurrentPosition (position) ->
      latlng = position.coords
      options = {mapTypeId: google.maps.MapTypeId.ROADMAP, mapTypeControl: false,  streetViewControl: false, zoom: 14}
      options['center'] = new google.maps.LatLng(latlng.latitude, latlng.longitude)
      map = new google.maps.Map($("#map").get(0), options)

  $(".post_comment").click ->
    id = @id.split("_").pop()
    $.get(@href + ".json")
    .success (response) ->
      [lat, lng] = response.location
      latlng = new google.maps.LatLng(lat, lng)
      map.panTo latlng
      infowindow = new google.maps.InfoWindow(position: latlng)
      frame = $("<div>")
      frame.append($("<p>").text(response.comment))
      frame.append($("<img>").attr(src: "#{path.root}/uploads/post/photo/#{response._id}/thumb_#{response.photo_filename}"))
      infowindow.setContent(frame.html())
      infowindow.open(map)
    return false