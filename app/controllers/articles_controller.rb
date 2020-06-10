class ArticlesController < ApplicationController
	before_action :set_article, only: [:show, :update, :destroy]

	def index
		@articles = Article.all
		json_response(@articles)
	end

	def show
		json_response(@article)
	end

	private

	def article_params
		params.permit(:title, :content)
	end

	def set_article
		@article = Article.find(params[:id])
	end
end
