class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites

  def favorited_by?(user)
    favorites.pluck(:user_id).include?(user.id)
  end
end
