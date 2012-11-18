class @Search

  constructor : (@r) ->
    $("header").hide()
    @el = $ """<form id="start_search">
      <h1>Beat. Brush.</h1>
        <input type="text" id="musicSearch">
        <input type="submit">
        <p class="status"></p>
      </form>"""
    @el.hide()

  footer : ->
    if @r.authenticated()
      $("")
    else
      $("<p class='signup'><a href=#>Authenticate with RDio</a> for full tracks.</p>").click ->
        r.authenticate()
        $(@).fadeOut()

  init : ->
    $('.new-search a').click =>
      $('#art').html('')
      $('#results').html('')
      $('#music').html('')
      @el.fadeIn()
      $('header').fadeOut()
    @r.ready =>
      @el.append(@footer())
      @el.fadeIn().submit (e) =>
        @el.find('.status').html('')
        terms = $('#musicSearch').val()
        search = new MusicSearch(terms)
        search.search (results) =>
          if _.any?(results)
            @el.fadeOut()
            $('header').fadeIn()
          else
            @el.find('.status').html('No results found.')
        e.preventDefault()
        false
