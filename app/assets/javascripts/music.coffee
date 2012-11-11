$ ->

  R.ready ->
    $('#search').fadeIn().submit (e) ->

      terms = $('#musicSearch').val()

      search = new MusicSearch(terms)
      search.search()

      e.preventDefault()
      false
