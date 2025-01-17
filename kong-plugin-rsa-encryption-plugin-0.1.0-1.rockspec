package = "kong-plugin-rsa-encryption-plugin"
version = "1.0.0-1"
rockspec_format = "1.0"
source = {
  url = "file://."
}
dependencies = {
  "lua >= 5.1",
  "kong >= 3.0",
  "lua-openssl"
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.encryption-plugin.handler"] = "handler.lua",
    ["kong.plugins.encryption-plugin.schema"] = "schema.lua"
  }
}
