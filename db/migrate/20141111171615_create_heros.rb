class CreateHeros < ActiveRecord::Migration
  def self.up
    create_table :heros do |t|
      t.string :name
      t.date :undoable_date
    end
  end

  def self.down
    drop_table :heros
  end
end
