# encoding: utf-8

require_relative '../spec_helper'

describe Gracenote do

  describe ".fetch_lyrics" do
    use_vcr_cassette

    it "returns the full lyrics back" do
      lyrics = Gracenote.fetch_lyrics("159760356-CC8504FCCA319152F7475B092F04743D")
      lyrics.should match(/Mutha’ucka charge a two buck transaction fee/)
    end
  end

  describe ".query" do
    use_vcr_cassette

    it "returns three tracks with a word we're looking for" do
      tracks = Gracenote.query(["hat"])
      tracks.each do |t|
        t[:lyrics].should match(/\bhat\b/)
        [:name, :artist, :lyrics, :gr_id, :context].each do |s|
          t[s].should be_present
        end
      end
    end
  end

end
