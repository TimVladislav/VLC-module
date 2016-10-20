require 'rubygems'
require 'zip'

class ZipFileController
  def initialize(input_dir, output_file)
    @input_dir = input_dir
    @output_file = output_file
    @json = "{ \n"
    @dir = ""
    @i = 0
  end

  def write
    entries = Dir.entries(@input_dir) - %w(. ..)

    ::Zip::File.open(@output_file, ::Zip::File::CREATE) do |io|
      write_entries entries, '', io
    end
    @json = @json.to_s[0..-2] + "\n}"
    File.open(@input_dir+'/config.json', "w+") do |f|
      f.write(@json)
    end

    ::Zip::File.open(@output_file) do |io|
      io.get_output_stream('config.json') do |f|
        f.puts(File.open(Rails.root + @input_dir + "config.json", 'rb').read)
      end
    end
  end

  private

  def write_entries(entries, path, io)
    entries.each do |e|
      zip_file_path = path == '' ? e : File.join(path, e)
      disk_file_path = File.join(@input_dir, zip_file_path)

      if File.directory? disk_file_path
        @dir = disk_file_path
        recursively_deflate_directory(disk_file_path, io, zip_file_path)
      else
        if File.extname(disk_file_path) == ".js"
          @json += "\n  \"add_file_#{@i}\":{ \n"
          @json += "    \"device_id\" : \"#{@id = @dir.to_s[@dir.to_s.rindex("/")+1..-1]}\", \n"
          @json += "    \"json_file\" : \"#{@id.to_s + "/" + disk_file_path.to_s[disk_file_path.to_s.rindex("/")+1..-1]}\" \n"
          @json += "  },"
          @i += 1
        end
        put_into_archive(disk_file_path, io, zip_file_path)
      end
    end
  end

  def recursively_deflate_directory(disk_file_path, io, zip_file_path)
    io.mkdir zip_file_path
    subdir = Dir.entries(disk_file_path) - %w(. ..)
    write_entries subdir, zip_file_path, io
  end

  def put_into_archive(disk_file_path, io, zip_file_path)
    io.get_output_stream(zip_file_path) do |f|
      f.puts(File.open(Rails.root + disk_file_path, 'rb').read)
    end
  end
end
