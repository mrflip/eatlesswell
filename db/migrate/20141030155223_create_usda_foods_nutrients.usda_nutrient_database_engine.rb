# This migration comes from usda_nutrient_database_engine (originally 3)
class CreateUsdaFoodsNutrients < ActiveRecord::Migration
  def change
    create_table :usda_foods_nutrients do |t|
      t.integer :food_id,         null: false
      t.integer :nutrient_id,     null: false
      t.float   :val,           null: false
      t.boolean :enrichment
      #
      t.integer :num_data_points, null: false
      t.float   :standard_error
      t.string  :source_id,        null: false
      t.string  :derivation_code
      t.string  :ref_food_id
      #
      t.integer :num_studies
      t.float   :min
      t.float   :max
      t.integer :degrees_of_freedom
      t.float   :lower_error_bound
      t.float   :upper_error_bound
      t.string  :statistical_comments
      t.string  :add_mod_date
      t.string  :confidence_code
    end

    add_index :usda_foods_nutrients,
      [:food_id, :nutrient_id],
      name: 'foods_nutrients_index', unique: true

    add_index :usda_foods_nutrients,
      [:nutrient_id],
      name: 'nutrients_index'
  end
end
