class @StartSearch
  constructor : ->
    @el = $ """<form id="start_search">
      <h1>Beat. Brush.</h1>
        <input type="text" id="musicSearch">
        <input type="submit">
        <p class="status"></p>
      </form>"""
    @el.hide()

  el : -> @el

  init : ->
    $('.new-search').click =>
      $('#art').html('')
      $('#results').html('')
      @el.fadeIn()
      $('.new-search').fadeOut()
    R.ready =>
      @el.fadeIn().submit (e) =>
        @el.find('.status').html('')
        terms = $('#musicSearch').val()
        search = new MusicSearch(terms)
        search.search (results) =>
          if _.any?(results)
            @el.fadeOut()
            $('.new-search').fadeIn()
          else
            @el.find('.status').html('No results found.')
        e.preventDefault()
        false