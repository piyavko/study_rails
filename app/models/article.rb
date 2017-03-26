class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :name, :description, :content, presence: true
  validates :description, length: {maximum: 300}
end
