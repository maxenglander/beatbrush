require_relative '../spec_helper'

describe MusicController do
  describe 'GET lyrics' do
    let(:lyrics) { [ "some json object..."] }
    before { Gracenote.stub(:fetch_lyrics) { lyrics } }

    it 'should query Gracenote' do
      Gracenote.should_receive(:fetch_lyrics).with("123")
      get :lyrics, gr_id: "123", format: :js
      response.should be_success
    end

    it 'should return json' do
      get :lyrics, gr_id: "123", format: :js
      response.body.should eq({ lyrics: lyrics}.to_json)
    end
  end

  describe 'GET search' do
    let(:results) { ['some','json','results...'] }
    before { Gracenote.stub(:query) { results } }

    it 'should query Gracenote' do
      Gracenote.should_receive(:query).with(["one", "two", "three"])
      get :search, words: "one two three", format: :js
      response.should be_success
    end

    it 'should return json' do
      get :search, words: "one two three", format: :js
      response.body.should eq(results.to_json)
    end
  end
end
