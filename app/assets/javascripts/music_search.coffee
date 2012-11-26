class window.MusicSearch
  constructor : (@words) ->

  search : (callback) =>
    Utility.setSearchTerm(@words)
    $.ajax
      url: "/music/search"
      data:
        words: @words
      dataType: "JSON"
      success: (resp) =>
        $('#results').html('')
        setTimeout( ->
          $('#music_search').fadeOut()
        , 200)

        tracks = _.map resp, (o) =>
          new Track
            name : o.name
            artist: o.artist
            lyric_snippet: o.lyrics
            gr_id: o.gr_id
            search_words: @words

        callback.call(this, tracks) if callback?

      error: @handleError

  searchAndPlay : (callback) =>
    @search (tracks) ->
      callback.call(this, tracks) if callback?
      if tracks.length is 0
        $('header .notice').show().text("No music found. Try again.")
        $('header button').one 'click', ->
          $('header .notice').fadeOut()
      else
        current = Utility.current_track
        selectedTrack = undefined

        # Pick a track
        _.each tracks, (track) =>
          return if (selectedTrack)
          if ((track.get('name') isnt current.get('name')) && 
              (track.get('artist') isnt current.get('artist')))
            selectedTrack = track
            track.loadRdio ->
              $('#music').html(track.el)
              track.activate()

  handleError : (resp) =>
    console.log('error!', resp)
