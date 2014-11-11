class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.references :hero
      t.date :sdate

      t.timestamps
    end
  end

  def self.down
    drop_table :schedules
  end
end
