$ ->

  window.startSearch = new StartSearch
  $('#content').prepend(startSearch.el)
  startSearch.init()
