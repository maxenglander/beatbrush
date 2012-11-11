$(document).ajaxComplete (event, xhr) ->
  $('#ajax-loader').hide()

$(document).ajaxStart (event, xhr) ->
  $('#ajax-loader').show()
