class CreateLabs < ActiveRecord::Migration
  def change
    create_table :labs do |t|
      t.string  :title
      t.string  :description
      t.string  :guide
      t.integer :class_study
      t.string  :department
      t.string  :topic

      t.timestamps null: false
    end
  end
end
