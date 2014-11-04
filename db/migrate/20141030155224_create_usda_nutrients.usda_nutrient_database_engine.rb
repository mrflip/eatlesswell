# This migration comes from usda_nutrient_database_engine (originally 4)
class CreateUsdaNutrients < ActiveRecord::Migration
  def change
    create_table :usda_nutrients do |t|
      # :id
      t.string  :units,             null: false
      t.string  :tagname
      t.string  :description,       null: false
      t.integer :frac_digits,       null: false
      t.integer :sortorder,         null: false
    end
  end
end
