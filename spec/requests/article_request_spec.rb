require 'rails_helper'

RSpec.describe "Articles API", type: :request do
	let!(:articles) { create_list(:article, 10) }
	let(:article_id) { articles.first.id }

	# test suite for GET /articles
	describe 'GET /articles' do
		# HTTP GET request
		before { get '/articles' }

		# Json is a custom helper to parse json responses
		it 'return articles' do
			expect(json).not_to be_empty
			expect(json.size).to eq(10)
		end

		it 'resturn status code 200' do
			expect(response).to have_http_status(200)
		end
	end

	# Test suite for GET /articles/:id
  describe 'GET /articles/:id' do
    before { get "/articles/#{article_id}" }

    context 'when the record exists' do
      it 'returns the article' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(article_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:article_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match("{\"message\":\"Couldn't find Article with 'id'=100\"}")
      end
    end
  end
end
