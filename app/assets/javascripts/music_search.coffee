class window.MusicSearch
  constructor : (@words) ->

  search : =>

    $.ajax
      url: "/music/search"
      data:
        words: @words
      dataType: "JSON"
      success: @handleResponse
      error: @handleError

  handleResponse : (resp) =>
    $('#results').html('')
    $('#search').fadeOut()
    _.each resp, (o) =>
      track = new Track(o.name, o.artist, o.lyrics, o.gr_id, @words)
      $('#results').append(track.el)
      track.loadRdio ->
        track.el.click ->
          $('#results .music').not(track.el).fadeOut -> $(@).remove()



  handleError : (resp) =>
    console.log('error!', resp)
