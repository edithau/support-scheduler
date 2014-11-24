class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.references :user, index: true
      t.date :date
    end
    add_index :assignments, :date, unique: true
  end

  def self.down
    drop_table :assignments
  end
end
