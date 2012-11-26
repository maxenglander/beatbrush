require_relative '../spec_helper'

describe ArtsController do
  describe 'GET search' do
    context 'one search term' do
      use_vcr_cassette

      let(:term) { "mango" }

      it 'should get some results' do
        get :search, term: term
        resp = JSON.parse(response.body)
        resp[0]["term_contexts"][0].should match(/mango/)
      end
    end

    context 'two search terms' do
      use_vcr_cassette

      let(:term) { "mango tree" }
      it 'should get some results' do
        get :search, term: term
        resp = JSON.parse(response.body)
        resp[0]["term_contexts"][0].should match(/mango tree/)
      end
    end
  end
end
