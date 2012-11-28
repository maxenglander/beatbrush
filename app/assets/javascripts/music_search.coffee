class window.MusicSearch
  constructor : (@words) ->

  search : (callback) =>
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
        BeatBrush.beat()
      else
        current = BeatBrush.currentTrack
        selectedTrack = undefined
        didActivate = false

        if !current?
          tracks[0].loadRdio ->
            $('#music').html(tracks[0].el)
            tracks[0].activate()
            BeatBrush.currentTrack = tracks[0]
        else
        # Pick a track
          _.each tracks, (track) =>
            return if (selectedTrack)
            if ((track.get('name') isnt current.get('name')) && 
                (track.get('artist') isnt current.get('artist')))
              selectedTrack = track
              didActivate = true
              track.loadRdio ->
                $('#music').html(track.el)
                track.activate()
                BeatBrush.currentTrack = track

          if (!didActivate)
            BeatBrush.beat()


  handleError : (resp) =>
    console.log('error!', resp)
