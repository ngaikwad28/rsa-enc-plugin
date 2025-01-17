local helpers = require "spec.helpers"

describe("encryption-plugin", function()
  local client

  lazy_setup(function()
    helpers.start_kong({
      plugins = "bundled,encryption-plugin",
      custom_plugins = "encryption-plugin",
    })
  end)

  lazy_teardown(function()
    helpers.stop_kong()
  end)

  before_each(function()
    client = helpers.proxy_client()
  end)

  after_each(function()
    if client then
      client:close()
    end
  end)

  it("encrypts the response using the provided public key", function()
    -- Add service and route
    local service = assert(helpers.dao.services:insert {
      name = "test-service",
      url = "http://httpbin.org"
    })

    local route = assert(helpers.dao.routes:insert {
      service = { id = service.id },
      protocols = { "http" },
      hosts = { "test.com" }
    })

    -- Add plugin configuration
    assert(helpers.dao.plugins:insert {
      name = "encryption-plugin",
      route_id = route.id,
      config = {
        public_key = [[
          -----BEGIN PUBLIC KEY-----
          <Your RSA Public Key Here>
          -----END PUBLIC KEY-----
        ]]
      }
    })

    -- Send a request
    local res = assert(client:send {
      method = "GET",
      path = "/get",
      headers = {
        ["Host"] = "test.com"
      }
    })

    assert.response(res).has.status(200)
    local body = assert.response(res).has.header("Content-Type")
    assert.is_true(body:match("^[a-zA-Z0-9+/]+=*$")) -- Base64 encrypted response
  end)
end)
