jQuery ($) ->
  geolocation = navigator.geolocation
  map = null

  if location.pathname == '/'
    geolocation.getCurrentPosition (position) ->
      latlng = position.coords
      options = {mapTypeId: google.maps.MapTypeId.ROADMAP, mapTypeControl: false,  streetViewControl: false, zoom: 14}
      options['center'] = new google.maps.LatLng(latlng.latitude, latlng.longitude)
      map = new google.maps.Map($("#map").get(0), options)

  selected = null
  selected_color = '#FFDDEE'
  comments = $('.post-comment')

  select = (node) ->
    if selected
      selected.css('backgroundColor', '#FFFFFF')
      selected.unbind('selected:mouseover')
      selected.unbind('selected:mouseout')
    node = $(node)
    node.css('backgroundColor', selected_color)
    node.bind 'selected:mouseover', ->
      $(@).css('backgroundColor', selected_color)
    node.bind 'selected:mouseout', ->
      $(@).css('backgroundColor', selected_color)
    selected = node

  $('.post-comment-link').live 'click', ->
    $(@).parent().click()
    return false

  comments.live 'mouseover', ->
    node = $(@)
    node.css('backgroundColor', '#D5E2FF')
    node.trigger('selected:mouseover')

  comments.live 'mouseout', ->
    node = $(@)
    node.css('backgroundColor', '#FFFFFF')
    node.trigger('selected:mouseout')

  comments.live 'click', ->
    select(@)
    id = @id.split("-").pop()
    href =  $(@).find('a').attr('href')
    $.get(href + ".json")
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

  $(".pagination a").live "ajax:success", (e, response)->
    $("#list").html(response)