local ngx = ngx
local kong = kong
local openssl_pkey = require("openssl.pkey")

local EncryptionPlugin = {}

-- Constructor
function EncryptionPlugin:new()
  local obj = {}
  setmetatable(obj, self)
  self.__index = self
  return obj
end

-- Header filter phase to remove Content-Length header
function EncryptionPlugin:header_filter()
  ngx.header["Content-Length"] = nil
end

-- Body filter phase to encrypt the response body
function EncryptionPlugin:body_filter(conf)
  local chunk = ngx.arg[1]
  local eof = ngx.arg[2]

  if not ngx.ctx.buffer then
    ngx.ctx.buffer = ""
  end

  if chunk then
    ngx.ctx.buffer = ngx.ctx.buffer .. chunk
    ngx.arg[1] = nil -- Clear the chunk to avoid outputting unencrypted data
  end

  if eof then
    local public_key = conf.public_key
    if not public_key then
      kong.log.err("Public key not configured in the plugin")
      ngx.arg[1] = ngx.ctx.buffer -- Send the original response if encryption fails
      return
    end

    local pkey, err = openssl_pkey.new(public_key)
    if not pkey then
      kong.log.err("Failed to load public key: ", err)
      ngx.arg[1] = ngx.ctx.buffer -- Send the original response if encryption fails
      return
    end

    local encrypted, err = pkey:encrypt(ngx.ctx.buffer)
    if not encrypted then
      kong.log.err("Failed to encrypt response: ", err)
      ngx.arg[1] = ngx.ctx.buffer -- Send the original response if encryption fails
      return
    end

    ngx.arg[1] = ngx.encode_base64(encrypted) -- Send Base64-encoded encrypted response
  end
end

-- Define the plugin priority and version
EncryptionPlugin.PRIORITY = 10
EncryptionPlugin.VERSION = "1.0.0"

return EncryptionPlugin
