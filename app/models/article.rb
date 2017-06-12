class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :name, :description, :content, presence: true
  validates :name, length: {maximum: 200}
  validates :description, length: {maximum: 300}
  
  validates :user_id, presence: true
end
