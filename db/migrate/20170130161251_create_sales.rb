class CreateSales < ActiveRecord::Migration[5.0]
  def change
    create_table :sales do |t|
      t.references :product, foreign_key: true
      t.decimal :cost
      t.date :date_of_purchase
    end
  end
end
