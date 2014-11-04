# This migration comes from usda_nutrient_database_engine (originally 6)
class CreateUsdaFootnotes < ActiveRecord::Migration
  def change
    create_table :usda_footnotes do |t|
      t.integer :food_id,         null: false
      t.integer :nutrient_id,                  index: true
      t.integer :seq,             null: false
      #
      t.string  :kind,            null: false
      t.string  :body,            null: false
    end

    add_index :usda_footnotes,
      [:food_id, :nutrient_id, :seq],
      name: 'footnotes_nutrients_index', unique: true

  end
end
