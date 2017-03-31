local url = require "net.url"

local _M = {}

local function buildHostHeader(newHost)
  local u = url.parse(newHost)
  local hostHeader = u.host
  if u.port then
    hostHeader = hostHeader .. ":" .. u.port
  end
  return hostHeader
end

local function replaceHost(url, newHost)
  local pathIndex = url:find('[^/]/[^/]')

  if not pathIndex then
    if newHost:find('[^/]/[^/]') == nil and newHost:sub(#newHost) ~= "/" then
      return newHost .. "/"
    end

    return newHost
  end

  if newHost:sub(#newHost) == "/" then
    newHost = newHost:sub(1, -2)
  end

  local path = url:sub(pathIndex + 1)
  return newHost .. path
end

function _M.execute(conf)
  ngx.var.upstream_host = buildHostHeader(conf.replacement_url)
  ngx.ctx.upstream_url = replaceHost(ngx.ctx.upstream_url, conf.replacement_url)
end

return _M
