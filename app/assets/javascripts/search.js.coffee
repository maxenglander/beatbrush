class @Search

  constructor : (@rdio, @musicSearcher) ->
    $("header").hide()
    @el = $ """<form id="start_search">
      <h1>Beat. Brush.</h1>
        <input type="text" id="musicSearch">
        <input type="submit">
        <p class="status"></p>
      </form>"""
    @el.hide()

  footer : ->
    if @rdio.authenticated()
      $("")
    else
      rdio = @rdio
      $("<p class='signup'><a href=#>Authenticate with RDio</a> for full tracks.</p>").click ->
        rdio.authenticate()
        $(@).fadeOut()

  init : ->
    $('.new-search a').click =>
      $('#art').html('')
      $('#results').html('')
      $('#music').html('')
      @el.fadeIn()
      $('header').fadeOut()
    @el.append(@footer())
    @el.fadeIn().submit @submit

  getTerms : ->
    $('#musicSearch', @el).val()

  clearStatus : -> @setStatus('')

  setStatus : (text) -> @el.find('.status').html(text)

  toggleOff : ->
    @el.fadeOut()
    $('header').fadeIn()

  submit : (e) =>
    @clearStatus()
    terms = @getTerms()
    search = new @musicSearcher(@getTerms())
    search.searchAndPlay (tracks) =>
      if _.any?(tracks)
        BeatBrush.setSearchTerm(terms)
        Art.search(@getTerms())
        @toggleOff()
        $('header .notice').fadeOut()
      else
        @setStatus('No results found.')
    e.preventDefault()
    false
