class Product < ApplicationRecord
  paginates_per 15
  has_many :sales, dependent: :destroy

  validates :name, presence: true,
                   uniqueness: true
end
