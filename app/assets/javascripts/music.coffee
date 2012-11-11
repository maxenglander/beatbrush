$ ->

  window.startSearch = new StartSearch
  $('body').prepend(startSearch.el)
  startSearch.init()
