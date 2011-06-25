# -*- coding: utf-8 -*-
class RootController < ApplicationController
  def index
    @posts = Post.order_by(:created_at.desc).page(params[:page]).per(20)
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
  end
end
