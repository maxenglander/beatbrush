class window.TrackMetadata
  constructor : (opts) ->
    @track = opts.track
    @artist = opts.artist

  fetch : (opts) ->
    $.ajax 
      url: "/lyrics/search"
      data :
        song_name : @track
        artist_name : @artist
      dataType : "JSON"
      success : opts.success
      error : opts.error
