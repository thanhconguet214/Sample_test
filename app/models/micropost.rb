class Micropost < ApplicationRecord
  belongs_to :user
  scope :des_post, -> {order(created_at: :desc)}
  scope :feed_id, -> (id){order(where user_id: :id)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.post}
  validate  :picture_size

  private

  def picture_size
    if picture.size > Settings.five_mb.megabytes
      errors.add :picture, I18n.t("models.micropost.five_mb")
    end
  end
end
