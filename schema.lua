local typedefs = require "kong.db.schema.typedefs"

return {
  name = "encryption-plugin",
  fields = {
    { consumer = typedefs.no_consumer },
    { protocols = typedefs.protocols_http }, -- Only for HTTP/HTTPS
    { config = {
        type = "record",
        fields = {
          { public_key = { type = "string", required = true, description = "The RSA public key for encrypting responses." } },
        },
      },
    },
  },
}
