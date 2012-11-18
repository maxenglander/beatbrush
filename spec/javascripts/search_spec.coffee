describe "Search", ->

  class MusicSearcherStub
    constructor : (@terms) ->
    search : (callback) -> callback(@results)
  
  class RdioStub
    authenticated : -> @authenticated
    authenticate : ->

  describe "submit", ->

    beforeEach ->
      @e = { preventDefault : -> }

    it "should clear status", ->
      class Stub
        search : ->
      search = new Search({}, Stub)
      spyOn(search, 'clearStatus')
      search.submit(@e)
      expect(search.clearStatus).toHaveBeenCalled()

    describe "with terms that produce results", ->
      theTerms = "one two three"
      class MusicSearcherSuccessStub
        constructor : (terms) ->
          expect(terms).toBe(theTerms)
        search : (callback) => callback([1,2])

      it "should search with the terms, then toggle itself off", ->
        search = new Search({}, MusicSearcherSuccessStub)
        spyOn(search, 'toggleOff')
        search.getTerms = -> theTerms
        search.submit(@e)
        expect(search.toggleOff).toHaveBeenCalled()

    describe "with terms that don't produce results", ->
      class MusicSearcherFailStub
        search : (callback) => callback([])

      it "should not toggle off, and set the status to No Results Found", ->
        search = new Search({}, MusicSearcherFailStub)
        spyOn(search, 'setStatus')
        spyOn(search, 'toggleOff')
        search.submit(@e)
        expect(search.setStatus).toHaveBeenCalledWith("No results found.")
        expect(search.toggleOff).not.toHaveBeenCalled()

  describe "footer", ->
    describe "when authenticated", ->
      it "should not have an Rdio link", ->
        search = new Search({ authenticated: -> true }, {})
        obj = search.footer()
        expect(obj.text()).toBe("")

    describe "when not authenticated", ->
      it "should have an Rdio link", ->
        search = new Search({ authenticated: -> false }, {})
        obj = search.footer()
        expect(obj.text()).toMatch(/Authenticate with RDio/)

      it "should call authenticate() when the link is clicked", ->
        rdio =
          authenticated: -> false
          authenticate : -> # noop
        spyOn(rdio, 'authenticate')
        search = new Search(rdio, {})
        obj = search.footer()
        obj.click()
        expect(rdio.authenticate).toHaveBeenCalled()
