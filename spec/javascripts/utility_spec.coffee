describe "Utility", ->
  describe "stop_word", ->
    it "should recognize stop words", ->
      _.each ["a", "and", "the", "can't", "that's"], (word) ->
        expect(Utility.stop_word(word)).toBe(true)
