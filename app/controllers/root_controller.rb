class RootController < ApplicationController
  def index
    @posts = Post.order_by(:created_at.desc).page(params[:page]).per(20)
  end

  Process.kill(:INT, Horai.ws_pid) if Horai.ws_pid
  Horai.ws_pid = Process.fork do
    EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
      ws.onopen    { ws.send "Hello Client!"}
      ws.onmessage { |msg| ws.send "Pong: #{msg}" }
      ws.onclose   { puts "WebSocket closed" }
    end
  end
end
