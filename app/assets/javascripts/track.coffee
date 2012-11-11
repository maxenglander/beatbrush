class @Track

  constructor : (@name, @artist, @lyric_snippet, @gr_id, @search_words) ->
    @el = $("""<div class='music'>
      <div class="image"></div>
      <div class="data">
        <p class="name"></p>
        <p class="lyrics"></p>
      </div>
      </div>""")

  el : ->
    @el

  get_lyrics : ->
    if @full_lyrics?
      @full_lyrics
    else
      @lyric_snippet

  render : =>
    @el.find('.image').html("""<img src="#{@icon}">""") if @icon?
    @el.find('.name').html("""#{@name} <strong>#{@artist}</strong>""")
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
        @full_lyrics = resp.lyrics
        @render()
        @el.find('.image').slideUp()
        @el.addClass('withFullLyrics')
        @el.click => @findInterestingWord()

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

    Art.search word, (arts) ->
      if arts[0]?
        image = "<img src='#{arts[0].image_url(Art.SIZE_355)}' />"
        meta = arts[0].data.term_contexts.join("; ")
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
          R.player.play source: result.key
          @getFullLyrics()
        fn.apply(this)
        true

      error : (response) ->
        console.log('error')