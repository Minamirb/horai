`WEB_SOCKET_DEBUG = true;
 WEB_SOCKET_SWF_LOCATION = '/WebSocketMain.swf';`

jQuery.fn.serializeObject = () ->
  arrayData = this.serializeArray()
  objectData = {}

  $.each arrayData, () ->
    if this.value?
      value = this.value
    else
      value = ''

    if objectData[this.name]?
      unless objectData[this.name].push
        objectData[this.name] = [objectData[this.name]]

      objectData[this.name].push value
    else
      objectData[this.name] = value

  return objectData

jQuery ($)->
  if $("#ws-progress").length > 0
    progress = new html5jp.progress("ws-progress")
    progress.draw()

  form = $('#ws-form')
  progress_bar = $("#ws-progress")

  fire = (obj, name, data) ->
    event = $.Event(name)
    obj.trigger(event, data)
    return event.result != false

  form.bind 'ws:upload', (event) ->
    file = form.find('input[type=file]').get(0).files[0]
    try
      max_length = file.size
    catch e
      alert nyoibo.file_not_found
      return
    if max_length == 0
      alert nyoibo.file_not_found
      return
    chunk = 102400
    start = 0
    ws = new WebSocket("ws://localhost:3030/")

    fire(form, 'ws:before_upload')
    ws.onclose = ->
      progress.set_val(100)
      fire(form, 'ws:after_upload')
      progress.reset()
      ws = null

    ws.onmessage = (evt) ->
      switch evt.data
        when 'OK Ready'
          params = {filename: file.name, comment: $('#post_comment').val(), size: max_length, session_string:  $('#session_string').val()}
          for k, v of form.serializeObject()
            params[k] = v
          ws.send("JSON: " + JSON.stringify(params))
        when 'OK Bye'
          ws.close()
        when 'EMPTY'
          ws.send("QUIT")
        when 'NEXT'
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

  $('#ws-form input[type=submit]').click ->
    fire(form, 'ws:upload') if fire(form, 'ws:prepare_upload')
    return false
