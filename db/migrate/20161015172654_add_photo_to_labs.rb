class AddPhotoToLabs < ActiveRecord::Migration
  def change
    add_column :labs, :photo, :string
  end
end
