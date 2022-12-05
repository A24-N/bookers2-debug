class Group < ApplicationRecord

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 20 }

  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_one_attached :group_image

  def get_group_image(width,height)
    unless group_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      group_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
    group_image.variant(resize_to_limit: [width, height]).processed
  end

end
