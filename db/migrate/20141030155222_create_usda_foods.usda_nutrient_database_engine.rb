# This migration comes from usda_nutrient_database_engine (originally 2)
class CreateUsdaFoods < ActiveRecord::Migration
  def change
    create_table :usda_foods do |t|
      # :id
      t.integer :food_group_id,  index: true
      #
      t.string  :desc_full,      null: false
      t.string  :desc_abbr,      null: false
      t.string  :common_names
      #
      t.string  :manufacturer,   index: true
      t.boolean :survey
      t.string  :refuse_desc
      t.integer :refuse_pct
      t.float   :nitrogen_factor
      t.float   :protein_factor
      t.float   :fat_factor
      t.float   :carbohydrate_factor
    end
  end
end
