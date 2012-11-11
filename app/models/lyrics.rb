class Lyrics

  def initialize(lyrics)
    @lyrics=lyrics
  end

  # The least-used word that's more than three letters.
  def uncommon_word
    common = {}
    %w{ a and or to the is in be }.each{|w| common[w] = true}
    l = @lyrics.gsub(/\b[a-zA-Z]+\b/){|word| common[word.downcase] ? '' : word}.squeeze(' ')
    l = l.split(" ")
    l = l.select {|w| w =~ /^[a-zA-Z]{4,}$/}
    words = Hash.new { 0 }
    l.each{|w| words[w.downcase] += 1}
    words.sort_by { |word, num| num }.first[0]
  end

end
