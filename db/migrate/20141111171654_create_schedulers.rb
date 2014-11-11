class CreateSchedulers < ActiveRecord::Migration
  def self.up
    create_table :schedulers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :schedulers
  end
end
