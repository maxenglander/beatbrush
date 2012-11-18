$ ->

  if R?
    window.startSearch = new Search(R)
    $('#content').prepend(startSearch.el)
    startSearch.init()
