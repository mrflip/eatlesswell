# This migration comes from usda_nutrient_database_engine (originally 2)
class CreateUsdaFoods < ActiveRecord::Migration
  def change
    create_table :usda_foods, id: false, primary_key: :nutrient_databank_number do |t|
      t.string  :nutrient_databank_number, null: false, index: true
      t.string  :food_group_code, index: true
      t.string  :long_description, null: false
      t.string  :short_description, null: false
      t.string  :common_names
      t.string  :manufacturer_name
      t.boolean :survey
      t.string  :refuse_description
      t.integer :percentage_refuse
      t.float   :nitrogen_factor
      t.float   :protein_factor
      t.float   :fat_factor
      t.float   :carbohydrate_factor
    end
  end
end
