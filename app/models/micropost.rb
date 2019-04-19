class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.microposts_max}
  validate  :picture_size
  delegate :name, to: :user
  scope :feed, ->(id){where user_id: id}
  scope :order_by_time, ->{order created_at: :desc}
  private

  def picture_size
    return unless picture.size > Settings.picture_size.megabytes
      errors.add :picture, t("models.micropost.should_be")
  end
end
