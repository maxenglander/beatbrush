context = describe

describe "Track", ->

  describe "constructor", ->

    it "should set the Utility current track", ->
      track = new Track({})
      expect(Utility.current_track).toBe(track)

    it "should construct the dom element", ->
      el = (new Track({})).el
      _.each ['.image','.data','p.name','p.lyrics'], (sel) ->
        expect(el.find(sel)[0]).toBeTruthy()

    it "should expose itself as 'track' data on element", ->
      track = new Track({})
      expect(track.el.data('track')).toBe(track)

  describe "activate", ->

    context "with gracenote id", ->
      beforeEach ->
        @track = new Track { gr_id : "1234" }

      it "should AJAX request for the gracenote lyrics", ->
        spyOn($, 'ajax')
        @track.activate()
        # Ideally would test the parameters passed to $.ajax...
        expect($.ajax).toHaveBeenCalled()

  describe "_activateCallback", ->
    beforeEach ->
      @track = new Track { gr_id : "1234" }

    it "should set Utility.current_track", ->
      Utility.current_track = undefined
      @track._activateCallback()
      expect(Utility.current_track).toBe(@track)

    it "should add class 'activated' to el", ->
      @track._activateCallback()
      expect(@track.el.hasClass('activated')).toBe(true)

    it "should call the R.player with @key for source", ->
      r = # stub
        player :
          play : ->
      spyOn(r.player, 'play')
      @track.set('key', '1234')
      @track.set('R', r)
      @track._activateCallback()
      expect(r.player.play).toHaveBeenCalledWith source: '1234'

    it "should trigger 'activated' on the element", ->
      activated = false
      @track.el.bind 'activated', -> activated = true
      @track._activateCallback()
      expect(activated).toBe(true)
