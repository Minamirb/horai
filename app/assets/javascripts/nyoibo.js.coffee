class Nyoibo
  constructor: (@url, id) ->
    if $("##{id}").length > 0
      @progressbar = new html5jp.progress(id)
      @progressbar.draw()
      @prepare_upload = -> true
      @before_upload  = -> true
      @after_upload   = -> true
      @upload_abort   = -> true
  upload: (file, params={}) ->
    @errors = []
    return false unless @prepare_upload.apply(@)

    try
      filesize = file.size
    catch e
      @errors.push "file not found"
    if filesize == 0
      @errors.push "file size is zero"

    return false if @errors.length > 0

    chunk = 102400
    start = 0

    ws = new WebSocket(@url)
    @before_upload.apply(@)
    ws.progressbar = @progressbar
    ws.after_upload = @after_upload
    ws.upload_abort = @upload_abort
    ws.onclose = ->
      ws.progressbar.reset()
      ws = null

    ws.onmessage = (evt) ->
      switch evt.data
        when 'OK Ready'
          params['filename'] = file.name
          params['size']     = filesize
          ws.send("JSON: " + JSON.stringify(params))
        when 'OK Bye'
          ws.progressbar.set_val(100)
          ws.after_upload.apply(@)
          ws.close()
        when 'ABORT'
          ws.upload_abort.apply(@)
        when 'EMPTY'
          ws.send("QUIT")
          ws.progressbar.set_val(100)
        when 'NEXT'
          val = Math.floor(start / filesize * 100)
          ws.progressbar.set_val(val)
          stop = start + chunk - 1
          if stop >= filesize
            stop = filesize

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

@Nyoibo = Nyoibo