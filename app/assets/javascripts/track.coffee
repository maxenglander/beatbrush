class window.Track

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
        @el.click =>
          R.player.play source: result.key
          @getFullLyrics()
        fn.apply(this)
        true

      error : (response) ->
        console.log('error')
