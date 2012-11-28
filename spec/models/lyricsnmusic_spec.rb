# encoding: utf-8

require_relative '../spec_helper'

describe Lyricsnmusic do
  describe ".query" do
    context "search for 'hat'" do
      use_vcr_cassette

      it "returns three tracks with a word we're looking for" do
        tracks = Lyricsnmusic.query(["hat"])
        tracks.length.should eq(3)
      end

      it "contains the word we're looking for" do
        tracks = Lyricsnmusic.query(["hat"])
        tracks.each do |t|
          matches = t.map { |k,v| v =~ /hat/i }.compact
          matches.length.should be > 0
        end
      end
    end

    context "search for 'bob dylan'" do
      use_vcr_cassette

      it "should include a snippet of lyrics if lyric search not used" do
        tracks = Lyricsnmusic.query(["bob", "dylan"])
        tracks.each do |t|
          t[:lyrics].should be_present
        end
      end
    end

    context "search for regexp-containing string" do
      use_vcr_cassette

      it "should not blow up" do
        lambda do
          # an actual string from the app.
          tracks = Lyricsnmusic.query(["straw mij...goede...[in"])
        end.should_not raise_error
      end
    end

    context "bad UTF-8 in result" do
      use_vcr_cassette

      it "should not blow up" do
        lambda do
          # this search causes a bad UTF-8 formatted result
          tracks = Lyricsnmusic.query(["hollar","scene"])
        end.should_not raise_error
      end
    end
  end
end
