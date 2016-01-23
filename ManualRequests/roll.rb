require "socket"

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(" ")
  path, params = path_and_params.split("?")

  params = (params || "").split("&").each_with_object({}) do |pair, hash|
    key, value = pair.split("=")
    hash[key] = value
  end

  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept

  request_line = client.gets
  puts request_line

  next unless request_line

  # GET /?rolls=5&sides=9 HTTP/1.1

  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.0 200 OK"
  client.puts "ContentType: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"
  client.puts request_line
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre style='color: red'>"

  client.puts "<h1>Rolls!</h1>"
  rolls = params['rolls'].to_i
  sides = params['sides'].to_i

  rolls.times do
    client.puts "<p>", rand(sides) + 1, "</p>"
  end
  client.puts "</body>"
  client.puts "</html>"



  client.close
end
