class Article < ApplicationRecord
  validates :name, :description, :content, presence: true
  validates :description, length: {maximum: 200}
end
