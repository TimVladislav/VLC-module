class Device < ActiveRecord::Base
  mount_uploader :pic, DevUploader

  validates :title, uniqueness: true

  has_and_belongs_to_many :labs
end
