local newdecoder = require 'utils.lunajson.decoder'
local newencoder = require 'utils.lunajson.encoder'
local sax = require 'utils.lunajson.sax'
local uuid = require 'utils.uuid'
local base64 = require 'utils.base64'

uuid.randomseed(os.time())

return {
    jsonDecode = newdecoder(),
    jsonEncode = newencoder(),
    jsonNewparser = sax.newparser,
    jsonNewfileparser = sax.newfileparser,
    uuid = uuid,
    base64 = base64,
}
