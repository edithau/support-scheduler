class CreateHeroes < ActiveRecord::Migration
  def self.up
    create_table :heroes do |t|
      t.string :name, :null => false, :limit => 30
      t.date :undoable_date
    end
    add_index :heroes, :name, unique: true
  end

  def self.down
    drop_table :heroes
  end
end
