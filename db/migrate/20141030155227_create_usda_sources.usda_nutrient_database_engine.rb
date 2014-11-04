# This migration comes from usda_nutrient_database_engine (originally 7)
class CreateUsdaSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string  :description, null: false
    end
  end
end
