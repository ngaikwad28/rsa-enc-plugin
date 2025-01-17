local typedefs = require "kong.db.schema.typedefs"

return {
  name = "rsa-enc-plugin",
  fields = {
    { consumer = typedefs.no_consumer }, -- This plugin is applied globally or on services/routes
    { config = {
        type = "record",
        fields = {
          { public_key = {
              type = "string",
              required = true,
              description = "The RSA public key in PEM format used for encrypting responses.",
          }},
        },
    }},
  },
}
