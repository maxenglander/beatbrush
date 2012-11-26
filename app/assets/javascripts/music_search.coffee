class window.MusicSearch
  constructor : (@words) ->

  search : (callback) =>
    @searchCallback = callback

    $.ajax
      url: "/music/search"
      data:
        words: @words
      dataType: "JSON"
      success: (resp) =>
        @searchCallback.call(this, resp) if @searchCallback?
        $('#results').html('')
        setTimeout( ->
          $('#music_search').fadeOut()
        , 200)
        _.each resp, (o) =>
          track = new Track
            name: o.name
            artist: o.artist
            lyric_snippet: o.lyrics
            gr_id: o.gr_id
            search_words: @words
          $('#results').append(track.el)
          track.loadRdio ->
            track.el.click ->
              $('#music').html(track.el)
              $('#results .music').fadeOut -> $(@).remove()
      error: @handleError

  searchAndPlay : (callback) =>
    @searchCallback = callback

    $.ajax
      url: "/music/search"
      data:
        words: @words
      dataType: "JSON"
      success: (resp) =>
        @searchCallback.call(this, resp) if @searchCallback?
        $('#results').html('')
        setTimeout( ->
          $('#music_search').fadeOut()
        , 200)
        selectedTrack = undefined
        if resp.length is 0
          $('header .notice').show().text("No music found. Try again.")
          $('header button').one 'click', ->
            $('header .notice').fadeOut()
        _.each resp, (o) =>
          return if (selectedTrack)
          current = Utility.current_track
          if (o.name isnt current.name) && (o.artist isnt current.artist)
            track = new Track
              name: o.name
              artist: o.artist
              lyric_snippet: o.lyrics
              gr_id: o.gr_id
              search_words: @words
            selectedTrack = track
            track.loadRdio ->
              $('#music').html(track.el)
              track.getFullLyrics()
          else
            return
      error: @handleError

  handleError : (resp) =>
    console.log('error!', resp)
