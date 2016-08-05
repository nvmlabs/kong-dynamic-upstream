local access = require "../src/access"

describe ("access" , function ()

	setup(function()
		_G.ngx = {}
		_G.ngx.ctx = {}
	end)

	it ("should replace the url", function()
		ngx.ctx.upstream_url = "https://google.com/path"
		local conf = {}
		conf.replacement_url = "http://mockbin.com:8000"
	
		access.execute(conf)
		assert.equal(ngx.ctx.upstream_url, "http://mockbin.com:8000/path")
	end)

	it ("should maintain the query parameters", function()
		ngx.ctx.upstream_url = "https://google.com/?key=value&key2=value2"
		local conf = {}
		conf.replacement_url = "http://mockbin.com:8000"

        access.execute(conf)
        assert.equal(ngx.ctx.upstream_url, "http://mockbin.com:8000/?key=value&key2=value2")
    end)

	it ("should maintain the fragment identifier", function()
		ngx.ctx.upstream_url = "https://google.com/path#top"
		local conf = {}
		conf.replacement_url = "http://mockbin.com:8000"

         access.execute(conf)
         assert.equal(ngx.ctx.upstream_url, "http://mockbin.com:8000/path#top")
     end)

	it ("should numbers in the path", function()
		ngx.ctx.upstream_url = "https://google.com:8080/1234"
		local conf = {}
		conf.replacement_url = "http://mockbin.com"

         access.execute(conf)
         assert.equal(ngx.ctx.upstream_url, "http://mockbin.com/1234")
     end)
	
	it ("should include the path from the replacement url", function()
		ngx.ctx.upstream_url = "https://google.com:8080/1234"
		local conf = {}
		conf.replacement_url = "http://mockbin.com/5678"

         access.execute(conf)
         assert.equal(ngx.ctx.upstream_url, "http://mockbin.com/5678/1234")
     end) 
	
	it ("should ignore trailing slashes on the replacement url", function()
		ngx.ctx.upstream_url = "https://google.com:8080/1234"
		local conf = {}
		conf.replacement_url = "http://mockbin.com/5678/"

        access.execute(conf)
        assert.equal(ngx.ctx.upstream_url, "http://mockbin.com/5678/1234")
    end) 
end)
