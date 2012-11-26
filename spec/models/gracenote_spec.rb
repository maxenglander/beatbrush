# encoding: utf-8

require_relative '../spec_helper'

describe Gracenote do

  describe ".fetch_lyrics" do
    use_vcr_cassette

    context "with gr_id" do
      it "returns the full lyrics back" do
        lyrics = Gracenote.fetch_lyrics({
          "gr_id" => "159760356-CC8504FCCA319152F7475B092F04743D"
        })
        lyrics.should match(/Mutha’ucka charge a two buck transaction fee/)
      end
    end

    context "with title and artist" do
      it "calls fetch_gr_id and then itself again" do
        Gracenote.should_receive(:fetch_gr_id).
          with({ "title" => "foo", "artist" => "bar" }) {
            "159760356-CC8504FCCA319152F7475B092F04743D"
          }
        lyrics = Gracenote.fetch_lyrics({
          "title" => "foo", "artist" => "bar"
        })
        lyrics.should match(/Mutha’ucka charge a two buck transaction fee/)
      end
    end
  end

  describe ".fetch_gr_id" do
    use_vcr_cassette

    it "returns the full lyrics back" do
      resp = Gracenote.fetch_gr_id({"title" => "all in", "artist" => "flying lotus"})
      resp.should eq("285989016-0F3AAEEDA9351A79C04ED7B0004C37FF")
    end
  end

  describe ".query" do
    use_vcr_cassette

    it "returns three tracks with a word we're looking for" do
      tracks = Gracenote.query(["hat"])
      tracks.length.should eq(3)
      tracks.each do |t|
        t[:lyrics].should match(/\bhat\b/)
        [:name, :artist, :lyrics, :gr_id, :context].each do |s|
          t[s].should be_present
        end
      end
    end
  end

end
