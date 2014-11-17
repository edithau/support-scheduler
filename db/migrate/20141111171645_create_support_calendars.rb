class CreateSupportCalendars < ActiveRecord::Migration
  def self.up
    create_table :support_calendars do |t|
    end
  end

  def self.down
    drop_table :support_calendars
  end
end
