class CreateComics < ActiveRecord::Migration
  def change
    create_table :comics do |t|
      t.integer :day
      t.integer :month
      t.integer :year
      t.string :location

      t.timestamps
    end
  end
end
