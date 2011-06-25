jQuery ($)->
  geolocation = navigator.geolocation
  map = false
  progress = new html5jp.progress("progress")
  progress.draw()

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
    ws = new WebSocket("ws://localhost:8080/")
    $("#new_post").hide()
    $("#progress").show()
    ws.onmessage = (evt) ->
      switch evt.data
        when 'OK Ready'
          ws.send("filename: #{file.name}, comment: #{$('#post_comment').val()}, size: #{max_length}\n")
        when 'Finish'
          ws.close()
          ws = null
          progress.set_val(100)
          $("#notice").text('アップロードが完了しました')
          $("#new_post").get(0).reset()
          $("#new_post").show()
          $("#progress").hide()

          progress.reset()
        when 'Next'
          val = Math.floor(start / max_length * 100)
          progress.set_val(val)
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
          , 300

  $('#upload').click ->
    errors = []
    if $("#post_comment").val().length < 1
      errors.push("コメントを入力してください")
    if $("#post_photo").val().length < 1
      errors.push("ファイルを選択してください")
    if errors.length > 0
      $("#new_post_error").text(errors.join(" "))
      return false

    $("#new_post_error").text('')
    $("#notice").text('')
    $("#post_photo").trigger 'upload'
    return false
