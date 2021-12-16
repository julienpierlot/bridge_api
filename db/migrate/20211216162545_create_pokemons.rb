class CreatePokemons < ActiveRecord::Migration[6.1]
  def change
    create_table :pokemons do |t|
      t.string :name, null: false
      t.integer :base_experience, null: false
      t.integer :height, null: false
      t.integer :weight, null: false

      t.timestamps
    end
    add_index :pokemons, :name
  end
end
