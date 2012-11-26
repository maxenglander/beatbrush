context = describe

describe "Art", ->
  describe "constructor", ->
    it "sets the data property", ->
      art = new Art some: "info"
      expect(art.data).toEqual some: "info"

  describe "_all_interesting_words_sorted", ->
    it "takes the result of text() and sorts all interesting words by frequency", ->
      art = new Art
      spyOn(art, 'text').andReturn([ "funny, there are some funny interesting words in", "this funny sentence that are interesting" ])
      actual = art._all_interesting_words_sorted()
      expect(actual).toEqual [ "words", "sentence", "interesting", "funny" ]

  describe "test", ->
    it "returns the various description containers of the API", ->
      art = new Art
        physical_description : "one"
        materials_techniques: "two"
        descriptive_line: "three"
        history_note: "four"
      expect(art.text()).toEqual(["one", "two", "three", "four"])
