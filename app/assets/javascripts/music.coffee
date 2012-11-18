$ ->

  if R?
    window.startSearch = new StartSearch(R)
    $('#content').prepend(startSearch.el)
    startSearch.init()
