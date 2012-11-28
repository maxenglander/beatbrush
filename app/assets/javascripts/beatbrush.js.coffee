$ ->
  if R?
    hasStarted = false
    R.ready ->
      R.player.on "change:playState", (state) ->
        console.log("Play state changed to #{state}")
        if state is R.player.PLAYSTATE_STOPPED
          if hasStarted
            BeatBrush.beatnbrush()
        hasStarted = true
$ ->
  $('body').on 'click', '#beat',  BeatBrush.beat
  $('body').on 'click', '#brush', BeatBrush.brush

class @BeatBrush

  # Change both music & art.
  @beatnbrush : =>
    term = @currentTrack.findInterestingWord()
    @setSearchTerm(term)
    ms = new MusicSearch(term)
    ms.searchAndPlay()
    $('#music .music').addClass('slideOut')
    Art.search term
    $('#art > div').addClass('slideOut')

  @beat : =>
    if @currentArt?
      words = @currentArt.find_interesting_words()
      ms = new MusicSearch(words)
      ms.searchAndPlay()
      @setSearchTerm(words)
      $('#music .music').addClass('slideOut')
    else
      $('header .notice').show().text("No dice. Try brush.")
      $('header button').one 'click', ->
        $('header .notice').fadeOut()

  @brush : =>
    if @currentTrack?
      word = @currentTrack.findInterestingWord()
      Art.search word
      @setSearchTerm(word)
      $('#art > div').addClass('slideOut')

  @setSearchTerm : (term) ->
    $('#term').text("“"+term+"”")
