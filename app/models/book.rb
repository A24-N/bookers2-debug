class Book < ApplicationRecord

  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_tag_relations, dependent: :destroy
  has_many :tags, through: :book_tag_relations

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

#Scope 設定
  scope :latest, -> {order(created_at: :desc)}
  scope :star_count, -> {order(star: :desc)}


# 検索条件分岐
  def self.looks(search,word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

  def save_tag(sent_tags)
# タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.tags.pluck(:tag) unless self.tags.nil?
# 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - sent_tags
# 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = sent_tags - current_tags
# 古いタグを消す
    old_tags.each do |old|
      self.tags.delete Tag.find_by(tag: old)
    end
# 新しいタグを保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(tag: new)
      self.tags << new_post_tag
    end
  end
end
