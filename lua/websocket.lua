local server = require "resty.websocket.server"
local client = require "resty.websocket.client"

local spawn = ngx.thread.spawn
local wait = ngx.thread.wait

local function make_uri (scheme, host, port, path)
  return scheme .. "://" .. host .. ":" .. port .. path
end

local function from(wb, proxy_wb)
  while true do
    local data, typ, err = wb:recv_frame()
    local bytes, err = proxy_wb:send_text(data)
  end
end

local function to(wb, proxy_wb)
  while true do
    local data, typ, err = proxy_wb:recv_frame()
    local bytes, err = wb:send_text(data)
  end
end

local wb, err = server:new{
  timeout = 60000,  -- in milliseconds
  max_payload_len = 65535,
}

if not wb then
  ngx.log(ngx.ERR, "failed to new websocket: ", err)
  return ngx.exit(444)
end

local scheme = ngx.var.scheme
local host = ngx.var.host
local port = ngx.var.server_port
local path = ngx.var.request_uri

if scheme == "https" then
  scheme = "wss"
else
  scheme = "ws"
end

uri = make_uri(scheme, host, port, path)

proxy_wb, err = client:new{
  timeout = 60000,  -- in milliseconds
  max_payload_len = 65535,
}
ok, err = proxy_wb:connect(uri)

local threads = {
  spawn(from, wb, proxy_wb),
  spawn(to, wb, proxy_wb)
}
for i = 1, #threads do
  local ok, res = wait(threads[i])
end
