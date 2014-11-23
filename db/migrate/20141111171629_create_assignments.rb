class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.references :hero, index: true
      t.date :date
    end
  end

  def self.down
    drop_table :assignments
  end
end
