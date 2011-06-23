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

  $("#post_photo").bind 'upload', (event) ->
    ws = new WebSocket("ws://localhost:8080/")
    file = event.target.files[0]
    try
      max_length = file.size
    catch e
      alert 'ファイルが存在しません。もう一度ファイルを選択してください'
      return

    if max_length == 0
      alert 'ファイルが存在しません。もう一度ファイルを選択してください'
      return
    chunk = 102400
    start = 0
    ws.onmessage = (evt) ->
      switch evt.data
        when 'OK Ready'
          ws.send("filename: #{file.name}, comment: #{$('#post_comment').val()}, size: #{max_length}\n")
        when 'Finish'
          ws.close
        when 'Comment'
          ws.send("")
        when 'Next'
          stop = start + chunk - 1
          if stop >= max_length
            stop = max_length

          blob = if typeof(file.mozSlice) == "function"
                   file.mozSlice(start, stop)
                 else if typeof(file.webkitSlice) == "function"
                   file.webkitSlice(start, stop)
          start = stop
          reader = new FileReader()
          reader.onloadend = (e) ->
            ws.send(e.target.result)

          setTimeout ->
            reader.readAsBinaryString(blob)
          , 30

    # ws.onclose = ->
    #   console.log("close")


  $('#upload').click ->
    $("#post_photo").trigger 'upload'
    return false
