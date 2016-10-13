class Device < ActiveRecord::Base
  mount_uploader :pic, DevUploader

  validates :title, uniqueness: true
end
