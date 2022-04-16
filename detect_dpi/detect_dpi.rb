#!/usr/bin/env ruby
# detect_dpi.rb: HTTP Server for detect_dpi.js
require 'json'
require_relative 'http_server'

# expected location of this script: #{CREW_PREFIX}/lib/sommelier/detect_dpi/
CREW_PREFIX = File.expand_path('../../..', __dir__)

# start an HTTP server, wait for detect_dpi.js to upload screen DPI
socketThread = Thread.new do
  HTTPServer.start do |sock, uri, method|
    case method
    when 'GET' # this block will execute when Chrome is requesting resources from this server
      file_path = File.join(__dir__, uri.path)

      unless File.file?(file_path)
        sock.print HTTPHeader(404)
      else
        # return with the content of file if the file exists
        sock.print HTTPHeader(200, MimeType[ File.extname(file_path) ])
        sock.write File.binread(file_path)
      end
    when 'POST' # this block will execute when detect_dpi.js upload the screen DPI
      header, returned_json = sock.read_nonblock(1024).split("\r\n\r\n", 2)
      sock.print HTTPHeader(200)
      # store the returned json file as the return value of this thread
      Thread.current[:returned_json] = JSON.parse(returned_json, symbolize_names: true)
      Thread.exit
    end
  end
end

puts 'Detecting screen DPI, this may take a while...'
server_port = HTTPServer.get_port # get the port number the server using

# open detect_dpi.html in browser
system 'dbus-send', '--system', 
       '--type=method_call', '--print-reply',
       '--dest=org.chromium.UrlHandlerService',
       '/org/chromium/UrlHandlerService',
       'org.chromium.UrlHandlerServiceInterface.OpenUrl',
       "string:http://localhost:#{server_port}/detect_dpi.html"

# wait for the server
socketThread.join

dpi = socketThread[:returned_json][:dpi]

puts "\nScreen DPI (scaled): #{dpi}"

# write result to file
File.write "#{CREW_PREFIX}/etc/sommelier.dpi", dpi