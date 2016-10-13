class DevicesController < ApplicationController

  before_action :find_device_by_id, only: [:show, :edit, :update, :destroy]

  def index
    @devices = Device.all
    @i = 0
  end

  def show
  end

  def new
    @device = Device.new
  end

  def create
    @device = Device.new(device_params)
    if @device.save
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

end
