$ ->
  if R?
    hasStarted = false
    R.ready ->
      R.player.on "change:playState", (state) ->
        console.log("Play state changed to #{state}")
        if state is R.player.PLAYSTATE_STOPPED
          if hasStarted
            $('header button#beat').click()
        hasStarted = true
  $('#music').bind 'click', '.expand-lyrics', ->
    lyrics = $(@).find('.lyrics')
    if lyrics.is(':visible')
      lyrics.slideUp()
    else
      lyrics.slideDown()
    false


class @Track

  constructor : (attrs) ->
    if attrs?
      @_attrs = attrs
    else
      @_attrs = {}
    unless @get('R')?
      @set('R', window.R)
    Utility.current_track = @
    @el = $("""<div class='music'>
      <div class="image"></div>
      <div class="data">
        <p class="name"></p>
        <p class="expand-lyrics"><a href="#">Lyrics</a></p>
        <p class="lyrics"></p>
      </div>
      </div>""")
    @el.data track: @

  get : (name) ->
    @_attrs[name]

  set : (name, value) ->
    @_attrs[name] = value

  lyrics : ->
    if @get('full_lyrics')?
      @get('full_lyrics')
    else
      @get('lyric_snippet')

  render : =>
    @el.find('.image').html("""<img src="#{@get('icon')}">""") if @get('icon')?
    if @get('artist')? && @get('name')?
      @el.find('.name').html("""#{@get('name')}<br><strong>#{@get('artist')}</strong>""") 
    @el.find('.lyrics').html("""#{@lyrics()}""") if @lyrics()?

    if @get('search_words')?
      _.each @get('search_words').split(" "), (w) => @el.highlight(w)

    this

  # Set this track as the current track.
  # If gr_id (Gracenote ID) exists, query for
  # full lyrics.
  #
  # Accepts a callback to be called when activated.
  activate : ->
    $.ajax
      url: "/music/lyrics"
      type: "GET"
      dataType: "JSON"
      data:
        gr_id: @get('gr_id')
        title: @get('name')
        artist: @get('artist')
      success: (resp) =>
        @set 'full_lyrics', resp.lyrics
        @el.addClass('withFullLyrics')
        @el.find('.lyrics').html("""#{@lyrics()}""")
        @_activateCallback()

  _activateCallback : ->
    Utility.current_track = @
    @el.addClass('activated')
    [r, key] = [@get('R'), @get('key')]
    r.player.play source: key if r? and key?
    @el.trigger('activated')

  findInterestingWord : ->
    lyrics = @el.find('.lyrics').text()
    lyrics = _.reject lyrics.split(/[,.]?\s+/), (w) -> w.length < 4 || Utility.stop_word(w)
    frequencies = {}
    _.each lyrics, (l) ->
      d = l.toLowerCase()
      frequencies[d] = (frequencies[d] || 0) + 1
    sorted = _.sortBy _.keys(frequencies), (k) -> frequencies[k]

    # Take the last five and pick randomly.
    last = sorted.slice(-5)
    word = last[Math.floor(Math.random() * last.length)]
    $('.lyrics').removeHighlight()
    $('.lyrics').highlight(word)
    word

  loadRdio : (fn) ->
    @get('R').request
      method : "search"
      content :
        types : "Track"
        query : """#{@get('name')} #{@get('artist')}"""
      success : (response) =>
        result = response.result.results[0]
        @set 'name', result.name
        @set 'artist', result.artist
        @set 'icon', result.icon
        @set 'key', result.key
        @render()
        @el.one 'click', =>
          @activate()
        fn.apply(this)
        true

      error : (response) ->
        console.log('error')
