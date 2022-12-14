class BooksController < ApplicationController

  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @nbook = Book.new
    @book_comment = BookComment.new
    @tag = @book.tags
  end

  def index
    @tag=Tag.all

    if params[:latest]
      @books = Book.latest
    elsif params[:star_count]
      @books = Book.star_count
    else
      @books = Book.all
    end
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id

    tag_list = params[:book][:tag].split(',')
    if @book.save
      @book.save_tag(tag_list)
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    @tag_list = @book.tags.pluck(:tag).join(',')
  end

  def update
    @book = Book.find(params[:id])
    tag_list = params[:book][:tag].split(',')
    if  @book.update(book_params)
# このpost_idに紐づいていたタグを@oldに入れる
        @old_relations=BookTagRelation.where(book_id: @book.id)
# それらを取り出し、消す。消し終わる
        @old_relations.each do |relation|
          relation.delete
        end
        @book.save_tag(tag_list)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end



  private

  def book_params
    params.require(:book).permit(:title, :body, :star)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
