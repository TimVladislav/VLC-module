class AddHashColumnToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :html, :string
    add_column :devices, :style, :string
    add_column :devices, :basic_script, :string
    add_column :devices, :buttons_script, :string
    add_column :devices, :buttons_img, :string
  end
end
