require 'zip'
require 'json'
require 'fileutils'
class DevicesController < ApplicationController

  before_action :find_device_by_id, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:builder_button]

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

      flash[:success] = "Прибор '#{@device.title}' создан"
      redirect_to @device
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @device.update(device_params)
      flash[:success] = "Прибор '#{@device.title}' изменен"
      redirect_to @device
    else
      render 'edit'
    end
  end

  def destroy
    @d_t = @device.title
    @device.destroy
    flash[:success] = "Прибор '#{@d_t}' удален"
    redirect_to devices_path
  end

  def builder_button
    
    @id = params.require(:id)
    @device = Device.find(params[:id])

    @w = params.require(:device)[:w]
    @h = params.require(:device)[:h]
    @x1 = params.require(:device)[:x1]
    @y1 = params.require(:device)[:y1]
    @name = params.require(:device)[:name_n]
    @id_n = params.require(:device)[:id_n]
    @img_path = @device.pic.to_s[0..@device.pic.to_s.rindex('/')-1] + @device.pic.to_s[@device.pic.to_s.rindex('/')..@device.pic.to_s.rindex('.')-1] + '/buttons/' + @name + '.jpg';

    @css = "
    #" + params.require(:device)[:id_n] + " { 
      position: absolute;
      top: " + @y1 + "px;
      left: " + @x1 + "px;
    }"

    @fcss = File.open(Rails.root.to_s + '/public' + @device.pic.to_s[0..@device.pic.to_s.rindex('/')-1] + @device.pic.to_s[@device.pic.to_s.rindex('/')..@device.pic.to_s.rindex('.')-1] + '/style.css', 'a')
    @fcss.puts @css
    @fcss.close

    @html = "
    <a href='#' id='" + params.require(:device)[:id_n] + "'><img src='buttons/" + @name + ".jpg'/></a>
    "

    @fhtml = File.open(Rails.root.to_s + '/public' + @device.pic.to_s[0..@device.pic.to_s.rindex('/')-1] + @device.pic.to_s[@device.pic.to_s.rindex('/')..@device.pic.to_s.rindex('.')-1] + '/index.html', 'a')
    @fhtml.puts @html
    @fhtml.close

    @image = MiniMagick::Image.open(Rails.root.to_s + '/public' + @device.pic.to_s[0..@device.pic.to_s.rindex('/')-1] + @device.pic.to_s[@device.pic.to_s.rindex('/')..@device.pic.to_s.rindex('.')-1] + '/picture.jpg')
    @image.crop @w + "x" + @h + "+" + @x1 + "+" + @y1
    @image.write(Rails.root.to_s + '/public' + @device.pic.to_s[0..@device.pic.to_s.rindex('/')-1] + @device.pic.to_s[@device.pic.to_s.rindex('/')..@device.pic.to_s.rindex('.')-1] + '/buttons/' + @name + '.jpg')
    render 'builder_resize'
  end

  def builder_create
    @device = Device.new(device_params)
    if @device.save

      #Create device's folder
      params[:device][:name] = @device.pic.filename.to_s[0..@device.pic.filename.to_s.rindex('.')-1]
      directory_name = Rails.root.to_s + "/public/uploads/device/pic/#{@device.id}/" + params[:device][:name]
      Dir.mkdir(directory_name, 0700) unless Dir.exist?(directory_name)

      #Move picture in new package
      FileUtils.mv(Rails.root.to_s + '/public' + @device.pic.to_s, Rails.root.to_s + '/public' + @device.pic.to_s[0..@device.pic.to_s.rindex('/')] + params[:device][:name] + '/picture' + @device.pic.to_s[@device.pic.to_s.rindex('.')..-1])

      #Create button's folder
      directory_name = Rails.root.to_s + "/public/uploads/device/pic/#{@device.id}/" + params[:device][:name] + "/buttons"
      Dir.mkdir(directory_name, 0700) unless Dir.exist?(directory_name)

      #Generate & write 'config.json'
      @json_string = '{
        "html"      : "index.html",
        "style"     : "style.css",
        "basic_script"    : "script.js",
        "buttons_script"  : "none",
        "buttons_img"   : "/buttons/",
        "buttons":    {
        }
      }'

      File.open(Rails.root.to_s + "/public/uploads/device/pic/#{@device.id}/" + params[:device][:name] + '/config.json', "w") { |file| file.write @json_string }

      #Creating html, css, js files
      File.open(Rails.root.to_s + "/public/uploads/device/pic/#{@device.id}/" + params[:device][:name] + '/index.html', "w") { |file| file.write '' }
      File.open(Rails.root.to_s + "/public/uploads/device/pic/#{@device.id}/" + params[:device][:name] + '/style.css', "w") { |file| file.write '' }
      File.open(Rails.root.to_s + "/public/uploads/device/pic/#{@device.id}/" + params[:device][:name] + '/script.js', "w") { |file| file.write '' }

      #generate css
      @css = "
      /* --- Autogenerate --- */

      #buttons,
      #main {
        position: absolute;
      }"

      @fcss = File.open(Rails.root.to_s + '/public' + @device.pic.to_s[0..@device.pic.to_s.rindex('/')-1] + @device.pic.to_s[@device.pic.to_s.rindex('/')..@device.pic.to_s.rindex('.')-1] + '/style.css', 'a')
      @fcss.puts @css
      @fcss.close

      #generate html
      @html = "
      <!-- --- Autogenerate --- -->
      <!DOCTYPE html>
      <html>

          <head>
              <meta charset='utf-8'>
              <link rel='stylesheet' href='style.css'>
              
              <script type='text/javascript' src='https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js'></script>
              <script src='./script.js' type='text/javascript'></script>
          </head>
          <body>
              <img id='main' src='picture.jpg'/>
        <div id='buttons'>"

      @fhtml = File.open(Rails.root.to_s + '/public' + @device.pic.to_s[0..@device.pic.to_s.rindex('/')-1] + @device.pic.to_s[@device.pic.to_s.rindex('/')..@device.pic.to_s.rindex('.')-1] + '/index.html', 'a')
      @fhtml.puts @html
      @fhtml.close

      #Updating device in database
      @json_data_hash = JSON.parse(@json_string)
      @device.update(html: @json_data_hash["html"], style: @json_data_hash["style"], basic_script: @json_data_hash["basic_script"], buttons_script: @json_data_hash["buttons_script"], buttons_img: @json_data_hash["buttons_img"])



      flash[:success] = "Прибор '#{@device.title}' создан"
      render 'builder_index'
    else
      render 'builder_new'
    end
  end

  def builder_index
    @device = Device.find(params[:id])

    render 'builder_index'
  end

  def builder_new_button
    
  end

  def builder_success
    @device = Device.find(params[:id])

    @html = "
        </div>
      </body>
    </html>
    "

    @fhtml = File.open(Rails.root.to_s + '/public' + @device.pic.to_s[0..@device.pic.to_s.rindex('/')-1] + @device.pic.to_s[@device.pic.to_s.rindex('/')..@device.pic.to_s.rindex('.')-1] + '/index.html', 'a')
    @fhtml.puts @html
    @fhtml.close

    redirect_to @device
  end

  private

  def builder_new
    redirect_to 'builder_new'
  end

  

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
