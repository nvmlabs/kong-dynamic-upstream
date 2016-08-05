local _M = {}

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
  ngx.ctx.upstream_url = replaceHost(ngx.ctx.upstream_url, conf.replacement_url)
end

return _M
