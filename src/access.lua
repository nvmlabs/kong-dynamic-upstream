local _M = {}

local function replaceHost(url, newHost)
  local pathIndex = string.find(url, '[^/]/[^/]')

  if not pathIndex then
    return newHost
  end

  local path = string.sub(url, pathIndex + 1)
  return newHost .. path
end

function _M.execute(conf)
  ngx.ctx.upstream_url = replaceHost(ngx.ctx.upstream_url, conf.replacement_url)
end

return _M
