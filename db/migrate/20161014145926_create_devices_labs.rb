class CreateDevicesLabs < ActiveRecord::Migration
  def change
    create_table :devices_labs, id: false do |t|
      t.integer :device_id
      t.integer :lab_id
    end
  end
end
