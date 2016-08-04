package = "kong-dynamic-upstream"
version = "0.1.0-0"
source = {
  url = "..."
}
description = {
  summary = "A Kong plugin that sets different upstream URLs based on API and Consumer",
  license = "Apache 2.0"
}
dependencies = {
  "lua ~> 5.1"
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.dynamic-upstream.handler"] = "src/handler.lua",
    ["kong.plugins.dynamic-upstream.access"] = "src/access.lua",
    ["kong.plugins.dynamic-upstream.schema"] = "src/schema.lua"
  }
}
