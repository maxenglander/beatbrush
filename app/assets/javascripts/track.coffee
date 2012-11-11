$ ->
  R.ready ->
    R.player.on "change:playState", (state) ->
      if state is R.player.PLAYSTATE_STOPPED
        $('header button#beat').click()
  $("body").on "click", "#brush", -> 
    if Utility.current_track?
      Utility.current_track.findInterestingWord()


class @Track

  constructor : (@name, @artist, @lyric_snippet, @gr_id, @search_words) ->
    Utility.current_track = @
    @el = $("""<div class='music'>
      <div class="image"></div>
      <div class="data">
        <p class="name"></p>
        <p class="lyrics"></p>
      </div>
      </div>""")

  get_lyrics : ->
    if @full_lyrics?
      @full_lyrics
    else
      @lyric_snippet

  render : =>
    @el.find('.image').html("""<img src="#{@icon}">""") if @icon?
    @el.find('.name').html("""#{@name}<br><strong>#{@artist}</strong>""")
    @el.find('.lyrics').html("""#{@get_lyrics()}""")

    _.each @search_words.split(" "), (w) => @el.highlight(w)

    this

  getFullLyrics : ->
    $.ajax
      url: "/music/lyrics"
      type: "GET"
      dataType: "JSON"
      data:
        gr_id: @gr_id
      success: (resp) =>
        Utility.current_track = @
        @full_lyrics = resp.lyrics
        @render()
        @el.addClass('withFullLyrics')
        _.each @search_words.split(" "), (w) =>
          if @full_lyrics.toLowerCase().indexOf(w.toLowerCase()) >= 0
            @searchArt(w)
        R.player.play source: @key

  setupClickHandler : ->

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
    @searchArt(word)

  searchArt : (word) ->
    Art.search word, (arts) ->
      $("body").off "click", "#beat"
      $("body").on "click", "#beat", ->
        words = arts[0].find_interesting_words()
        ms = new MusicSearch(words)
        ms.searchAndPlay()
      if arts[0]?
        image = "<img src='#{arts[0].image_url(Art.SIZE_355)}' />"
        meta = arts[0].text().join("<br/><br/>")
        if arts[0].data.term_contexts?
          meta = meta.concat("<br/><br/>").concat(arts[0].data.term_contexts.join("; "))
        $('#art').html("<div>#{image}<p style='max-width:355px;'>#{meta}</p></div>").highlight(word)
      else
        $('#art').html("""<p>No art.</p>""")

  loadRdio : (fn) ->
    R.request
      method : "search"
      content :
        types : "Track"
        query : """#{@name} #{@artist}"""
      success : (response) =>
        result = response.result.results[0]
        @name = result.name
        @artist = result.artist
        @icon = result.icon
        @key = result.key
        @render()
        @el.one 'click', =>
          @getFullLyrics()
        fn.apply(this)
        true

      error : (response) ->
        console.log('error')
