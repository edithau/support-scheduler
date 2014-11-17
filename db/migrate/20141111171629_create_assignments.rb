class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.references :hero
      t.date :sdate
    end
  end

  def self.down
    drop_table :assignments
  end
end
