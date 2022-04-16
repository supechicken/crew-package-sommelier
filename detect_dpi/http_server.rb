# adapted from crew-launcher (lib/http_server.rb)
require 'socket'
require 'uri'

MimeType = {
  '.js' => 'application/javascript',
  '.json' => 'application/json',
  '.html' => 'text/html',
  '.png' => 'image/png',
  '.svg' => 'image/svg+xml',
}

def HTTPHeader (status_code, content_type = 'text/plain', extra = nil)
  status_msg = begin
    case status_code
    when 503
      'Service Unavailable'
    when 404
      'Not Found'
    when 200
      'OK'
    end
  end

  return <<~EOT.encode(crlf_newline: true)
    HTTP/1.1 #{status_code} #{status_msg}
    Content-Type: #{content_type}
    #{"#{extra}\n" if extra}
  EOT
end

module HTTPServer
  def self.get_port
    # wait until socket info is ready to read
    sleep(0.5) until @using_port
    # use regex to extract port number form socket info
    return @using_port.inspect[/:(\d+)\s/, 1].to_i
  end

  def self.start(&block)
    # let ruby find an unused port automatically by setting the port to 0
    server = TCPServer.new('localhost', 0)
    # store the socket info, used to get the socket port in self.get_port
    @using_port = server.local_address

    # add REUSEADDR option to prevent kernel from keeping the port
    server.setsockopt(:SOCKET, :REUSEADDR, true)

    begin
      Socket.accept_loop(server) do |sock, _|
        begin
          request = sock.gets
          next unless request # undefined method `split' for nil:NilClass

          method, path, _ = request.split(' ', 3)
          uri = URI(path)
          yield sock, uri, method
        rescue Errno::EPIPE
        ensure
          sock.close
        end
      end
    ensure
      server.close
    end
  end
end