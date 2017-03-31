local access = require "../src/access"

describe ("access" , function ()

  setup(function()
    _G.hostHeader = ""
    _G.ngx = {}
    _G.ngx.req = {}
    function ngx.req.set_header (name, value)
      if name == "host" then
        hostHeader = value
      end
    end
    _G.ngx.var = {}
    _G.ngx.ctx = {}
  end)

  it ("should replace the url", function()
    ngx.ctx.upstream_url = "https://google.com/path"
    local conf = {}
    conf.replacement_url = "http://mockbin.com:8000"

    access.execute(conf)
    assert.equal("http://mockbin.com:8000/path", ngx.ctx.upstream_url)
  end)

  it ("should update the Host header", function()
    ngx.ctx.upstream_url = "https://google.com/path"
    ngx.var.upstream_host = "google.com"
    local conf = {}
    conf.replacement_url = "http://www.mockbin.com:8000/api"

    access.execute(conf)
    assert.equal("www.mockbin.com:8000", ngx.var.upstream_host)
    assert.equal("www.mockbin.com:8000", hostHeader)
  end)

  it ("should maintain the query parameters", function()
    ngx.ctx.upstream_url = "https://google.com/?key=value&key2=value2"
    local conf = {}
    conf.replacement_url = "http://mockbin.com:8000"

    access.execute(conf)
    assert.equal("http://mockbin.com:8000/?key=value&key2=value2", ngx.ctx.upstream_url)
  end)

  it ("should maintain the fragment identifier", function()
    ngx.ctx.upstream_url = "https://google.com/path#top"
    local conf = {}
    conf.replacement_url = "http://mockbin.com:8000"

    access.execute(conf)
    assert.equal("http://mockbin.com:8000/path#top", ngx.ctx.upstream_url)
  end)

  it ("should numbers in the path", function()
    ngx.ctx.upstream_url = "https://google.com:8080/1234"
    local conf = {}
    conf.replacement_url = "http://mockbin.com"

    access.execute(conf)
    assert.equal("http://mockbin.com/1234", ngx.ctx.upstream_url)
  end)

  it ("should include the path from the replacement url", function()
    ngx.ctx.upstream_url = "https://google.com:8080/1234"
    local conf = {}
    conf.replacement_url = "http://mockbin.com/5678"

    access.execute(conf)
    assert.equal("http://mockbin.com/5678/1234", ngx.ctx.upstream_url)
  end)

  it ("should ignore trailing slashes on the replacement url", function()
    ngx.ctx.upstream_url = "https://google.com:8080/1234"
    local conf = {}
    conf.replacement_url = "http://mockbin.com/5678/"

    access.execute(conf)
    assert.equal("http://mockbin.com/5678/1234", ngx.ctx.upstream_url)
  end)

  it ("should ensure that the result has a slash if theres no path", function()
    ngx.ctx.upstream_url = "https://google.com:8080"
    local conf = {}
    conf.replacement_url = "http://mockbin.com"

    access.execute(conf)
    assert.equal("http://mockbin.com/", ngx.ctx.upstream_url)
  end)

  describe ("with just the replacement_url having a trailing slash" , function ()
    it ("should ensure that the result has only one ending slash", function()
      ngx.ctx.upstream_url = "https://google.com:8080"
      local conf = {}
      conf.replacement_url = "http://mockbin.com/"

      access.execute(conf)
      assert.equal("http://mockbin.com/", ngx.ctx.upstream_url)
    end)
  end)

  describe ("with just the upstream_url having a trailing slash" , function ()
    it ("should ensure that the result has only one ending slash", function()
      ngx.ctx.upstream_url = "https://google.com:8080/"
      local conf = {}
      conf.replacement_url = "http://mockbin.com"

      access.execute(conf)
      assert.equal("http://mockbin.com/", ngx.ctx.upstream_url)
    end)
  end)

  describe ("with both upstream_url and replacement_url having trailing slashes" , function ()
    it ("should ensure that the result has only one ending slash", function()
      ngx.ctx.upstream_url = "https://google.com:8080/"
      local conf = {}
      conf.replacement_url = "http://mockbin.com/"

      access.execute(conf)
      assert.equal("http://mockbin.com/", ngx.ctx.upstream_url)
    end)
  end)
end)
