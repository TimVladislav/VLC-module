class LabsController < ApplicationController

  before_action :find_lab_by_id, only: [:show, :edit, :update, :destroy]

  def index
    @labs = Lab.all
  end

  def show
    @i = 0
  end

  def new
    @lab = Lab.new
    @devices = Device.all
  end

  def create
    @lab = Lab.new(lab_params)
    puts params[:lab]
    if @lab.save

      Device.all.count.times do |i|
        @sym = "device#{i+1}".to_sym
        @id_device = params[:lab][@sym].to_i
        unless @id_device == 0
          @lab.devices << Device.find(@id_device)
        end
      end

      redirect_to @lab
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @lab.update (lab_params)
      redirect_to @lab
    else
      render 'edit'
    end
  end

  def destroy
    @lab.destroy
    redirect_to labs_path
  end

  private

  def find_lab_by_id
    @lab = Lab.find(params[:id])
  end

  def lab_params
    params.require(:lab).permit(:title, :description, :guide, :class_study, :department, :topic, :photo)
  end

end
