jQuery ($)->
  form = $('#ws-form')
  progress_bar = $("#ws-progress")

  form.bind 'ws:prepare_upload', (event) ->
    errors = []
    if $("#post_comment").val().length < 1
      errors.push("コメントを入力してください")
      # errors.push("")
    if $("#post_photo").val().length < 1
      errors.push("ファイルを選択してください")
      # errors.push("")
    if errors.length > 0
      $("#errors").text(errors.join(" "))
      return false

  form.bind 'ws:before_upload', (event) ->
    form.hide()
    progress_bar.show()

  form.bind 'ws:after_upload', (event) ->
    $("#notice").text('アップロードが完了しました')
    $("#list").load("/")
    form.get(0).reset()
    form.show()
    progress_bar.hide()

