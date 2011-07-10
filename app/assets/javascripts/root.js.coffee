`WEB_SOCKET_DEBUG = true;
 WEB_SOCKET_SWF_LOCATION = '/WebSocketMain.swf';`

jQuery ($)->
  form = $('#ws-form')
  progress_bar = $("#ws-progress")

  nyoibo = new Nyoibo("ws://localhost:3030/", "ws-progress")
  form = $('#ws-form')

  nyoibo.prepare_upload = ->
    if $("#post_comment").val().length < 1
      @errors.push "Comment is blank"
    return true

  nyoibo.before_upload  = ->
    form.hide()
    progress_bar.show()

  nyoibo.after_upload   = ->
    $("#notice").text('アップロードが完了しました')
    $("#list_ul").load(path.root + "/")
    form.get(0).reset()
    form.show()
    progress_bar.hide()

  nyoibo.upload_abort   = ->
    $("#errors").text("ファイルを送信できません");
    progress_bar.hide()
    form.show()

  $('#ws-form input[type=submit]').click ->
    params = {}
    for i, input of form.serializeArray()
      params[input.name] = input.value

    unless nyoibo.upload(form.find('input[type=file]').get(0).files[0], params)
      if nyoibo.errors.length > 0
        errors = $(nyoibo.errors).map (i, e) ->
          I18n.t[e]
        $("#errors").text(errors.toArray().join(", "))
    return false
