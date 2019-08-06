local http = require "resty.http.http"

local function make_uri (scheme, host, port, path, method, query_string)
  return scheme .. "://" .. host .. ":" .. port .. path
end

ngx.req.read_body()

local scheme = ngx.var.scheme
local host = ngx.var.host
local port = ngx.var.server_port
local path = ngx.var.request_uri
local method = ngx.var.request_method
local query_string = ngx.var.query_string
local body = ngx.req.get_body_data()
local headers = ngx.req.get_headers()

local uri = make_uri(scheme, host, port, path, method, query_string)

local httpc = http.new()

local res, err = httpc:request_uri(uri, {
  method = method,
  body = body,
  headers = headers,
  keepalive_timeout = 60,
  keepalive_pool = 10,
  ssl_verify = false
})

ngx.status = res.status

-- use response headers from upstream 
for k,v in pairs(res.headers) do
  ngx.header[k] = v
end

ngx.say(res.body)
