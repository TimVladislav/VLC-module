class LabsController < ApplicationController

  before_action :find_lab_by_id, only: [:show, :edit, :update, :code, :destroy]

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

  def code
    @device = Device.find(params[:device])
    #read json to hash
    @json_path = "public" + @device.pic.to_s[0..@device.pic.to_s.rindex(".")-1] + "/config.json"
    @json_file = File.read(@json_path)
    @json_data_hash = JSON.parse(@json_file)
    #---end---

    @img_path = @device.pic.to_s[0..-5] + @json_data_hash["buttons_img"].to_s
    @buttons = @json_data_hash["buttons"]

  end

  def codewrite
    @lab = Lab.find(params[:lab_id])
    @device = Device.find(params[:dev][:id])
    @button_selector = "#" + params[:but_s].to_s
    @text_code = params[:codewrite][:code]
    @path_js = "public/uploads/lab/photo/#{@lab.id}/#{params[:but_s]}.js"
    
    File.open(@path_js, "w+") do |f|
      f.write("$('#{@button_selector}').on('click', function(){\n")
      f.write(@text_code.to_s + "\n")
      f.write("});")
    end
    redirect_to @lab
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
