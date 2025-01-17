package = "rsa-enc-plugin"
version = "0.1.0-1"
rockspec_format = "1.0"
source = {
  url = "git://your-repository-url", -- Replace with your actual repository URL
}

description = {
  summary = "Kong plugin for RSA encryption of backend responses.",
  detailed = "This plugin encrypts backend responses using an RSA public key and encodes the result in Base64.",
  homepage = "https://your-plugin-homepage-url",
  license = "MIT",
}

dependencies = {
  "lua-resty-openssl >= 0.8.11",
  "kong >= 3.0.0",
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins.rsa-enc-plugin.handler"] = "kong/plugins/rsa-enc-plugin/handler.lua",
    ["kong.plugins.rsa-enc-plugin.schema"] = "kong/plugins/rsa-enc-plugin/schema.lua",
  },
}
