# This migration comes from usda_nutrient_database_engine (originally 5)
class CreateUsdaWeights < ActiveRecord::Migration
  def change
    create_table :usda_weights do |t|
      t.integer :food_id,                 null: false
      t.integer :seq,                     null: false
      #
      t.float   :amount,                  null: false
      t.string  :description,             null: false
      t.float   :gram_weight,             null: false
      t.integer :num_data_points
      t.float   :stddev
    end

    add_index :usda_weights,
      [:food_id, :seq],
      name: 'weights_index', unique: true

  end
end
