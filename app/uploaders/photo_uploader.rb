# encoding: utf-8
require 'carrierwave/processing/mini_magick'
class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process :resize_to_fit => [127, 178]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  Process.kill(:KILL, Horai.ws_pid) if Horai.ws_pid
  Horai.ws_pid = Process.fork do
    EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
      file = nil
      ws.onmessage{|message|
        case message
        when /^filename:/
          message.chomp!
          file = Hash[message.split(', ').map{|col| (k, v) = col.split(': '); [k.to_sym, v] }]
          if file[:comment].blank?
            response = "Error: {comment: 'required'}"
          else
            file[:size] = file[:size].to_i
            file[:body] = "".encode("BINARY")
            session = Horai::Application.config.session_store.new(Horai::Application).coder.decode(file[:session_string])
            file[:user_id] = session["user_id"]
            response = 'Next'
          end
        else
          message = message.unpack('U*').pack('c*')
          file[:body] << message
          if file[:body].bytesize >= file[:size]
            post = Post.new
            post.comment = file.delete(:comment)
            tmpfile = Tempfile.new("RackMultipart")
            tmpfile.binmode
            tmpfile.write file.delete(:body)
            file[:tempfile] = tmpfile
            file[:type] = "image/jpg"
            post.photo =  ActionDispatch::Http::UploadedFile.new(file)
            post.user_id = file[:user_id]
            post.save
            response = 'Finish'
          else
            response = 'Next'
          end
        end
        ws.send(response)
      }

      ws.onopen    { ws.send "OK Ready" }
      ws.onclose   { puts "WebSocket closed" }
    end
  end if Rails.env != "test"
end
