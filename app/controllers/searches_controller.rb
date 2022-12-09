class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]
    @nbook =Book.new

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
    elsif @range == "Book"
      @books = Book.looks(params[:search], params[:word])
    else
#タグ検索
      @range = "Tag"
      @word = params[:tag]
      @books = Book.where("tag LIKE?", "#{@word}")
    end
  end


end

