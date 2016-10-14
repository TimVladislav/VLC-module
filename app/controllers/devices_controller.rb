require 'zip'
require 'json'
class DevicesController < ApplicationController

  before_action :find_device_by_id, only: [:show, :edit, :update, :destroy]

  def index
    @devices = Device.all
    @i = 0
  end

  def show
    @img_path = @device.pic.to_s[0..@device.pic.to_s.rindex(".")-1] + "/picture.jpg"
  end

  def new
    @device = Device.new
  end

  def create
    @device = Device.new(device_params)
    if @device.save

      #unpacking .zip file
      @zip_path = "public" + @device.pic.to_s
      @destination = "public" + @device.pic.to_s[0..@device.pic.to_s.rindex("/")]
      unpackzip(@zip_path, @destination)
      #---end---

      #read json to hash
      @json_path = "public" + @device.pic.to_s[0..@device.pic.to_s.rindex(".")-1] + "/config.json"
      @json_file = File.read(@json_path)
      @json_data_hash = JSON.parse(@json_file)
      #---end---

      #write hash in DB
      @device.update(html: @json_data_hash["html"], style: @json_data_hash["style"], basic_script: @json_data_hash["basic_script"], buttons_script: @json_data_hash["buttons_script"], buttons_img: @json_data_hash["buttons_img"])
      #---end---

      redirect_to @device
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @device.update(device_params)
      redirect_to @device
    else
      render 'edit'
    end
  end

  def destroy
    @device.destroy
    redirect_to devices_path
  end

  private

  def device_params
    params.require(:device).permit(:title, :description, :pic)
  end

  def find_device_by_id
    @device = Device.find(params[:id])
  end

  def unpackzip(zip_path, destination)
    FileUtils.mkdir_p(destination)

    Zip::File.open(zip_path.to_s) do |zip_file|
      zip_file.each do |file|
        @file_path = File.join(destination, file.name)
        zip_file.extract(file, @file_path) unless File.exist?(@file_path)
      end
    end
  end

end
