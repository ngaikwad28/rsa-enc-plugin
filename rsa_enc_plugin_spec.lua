local PLUGIN_NAME = "rsa-enc-plugin"

describe(PLUGIN_NAME, function()
  local public_key = [[-----BEGIN PUBLIC KEY-----
YOUR_PUBLIC_KEY_HERE
-----END PUBLIC KEY-----]]

  it("should load with a valid configuration", function()
    local conf = { public_key = public_key }
    assert.has_no.errors(function()
      require("kong.plugins." .. PLUGIN_NAME .. ".handler").access(conf)
    end)
  end)

  it("should error with an invalid public key", function()
    local conf = { public_key = "invalid-key" }
    local handler = require("kong.plugins." .. PLUGIN_NAME .. ".handler")
    assert.has.errors(function()
      handler.access(conf)
    end, "Failed to load public key")
  end)
end)
