class Sale < ApplicationRecord
  paginates_per 30
  belongs_to :product

  validates :date_of_purchase, presence: true
  validates :product,          presence: true
  validates :cost,             presence: true,
                               numericality: { greater_than: 0 }
end
