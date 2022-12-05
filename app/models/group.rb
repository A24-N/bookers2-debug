class Group < ApplicationRecord

  has_many :groupusers
  # , dependent: :destroy
  has_one_attached :group_image

  def get_group_image(width,height)
    unless group_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      groupe_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
    groupe_image.variant(resize_to_limit: [width, height]).processed
  end

end
