class Lab < ActiveRecord::Base
  mount_uploader :photo, DevUploader
  has_and_belongs_to_many :devices
end
