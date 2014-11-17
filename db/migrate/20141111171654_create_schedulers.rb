class CreateSchedulers < ActiveRecord::Migration
  def self.up
    create_table :schedulers do |t|
    end
  end

  def self.down
    drop_table :schedulers
  end
end
