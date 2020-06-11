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

  # test suite for post /articles
  describe 'POST /articles' do
    # valid payload
    let(:valid_attributes) { { title: "Learn TDD", content: "Lorem" }}

    context 'when the request is valid' do
      before { post '/articles', params: valid_attributes }

      it 'create a article' do
        expect(json['title']).to eq(valid_attributes[:title])
        expect(json['content']).to eq(valid_attributes[:content])
      end

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/articles', params: { title: "Only title" } }

      it 'return a validation failure message' do
        expect(response.body).to match("{\"message\":\"Validation failed: Content can't be blank\"}")
      end

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  # test suite for put /articles/:id
  describe 'PUT /articles/:id' do
    let(:valid_attributes) { { title: "Updated title" } }

    context 'when the record exists' do
      before { put "/articles/#{article_id}", params: valid_attributes }

      it 'update the record' do
        expect(response.body).to be_empty
      end

      it 'return status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # test suite for delete /articles/:id
  describe 'DELETE /articles/:id' do
    before { delete "/articles/#{article_id}" }

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end
