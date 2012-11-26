$ ->

  if R?
    window.startSearch = new Search(R, MusicSearch)
    $('#content').prepend(startSearch.el)
    R.ready ->
      startSearch.init()
