# LuaMISP - Lua Library to create and manipulate MISP entities

# Requirements
LuaMISP relies on the following libraries:
- `lunajson` to encode MISP entities into JSON
- `uuid` to generate weak UUID
- `base64` to encode attribute's payload into base64

However, they are already included in this repository for convinience.

# Usage
```lua
local LuaMISP = require 'LuaMISP'

local event = Event:new({title='Test event from LuaMISP'})
event:addTags({'tag1', 'tag2'})

local attribute = Attribute:new({type='comment', value='attribute_1'})

local byteArray = ''
local attribute_attachment = Attribute:new({type='attachment', value='filename', data=byteArray})

local object = Object:new({type='domain-ip'})
local attribute_domain = Attribute:new({type='domain', value='google.com'})
local attribute_ip = Attribute:new({type='ip', value='8.8.8.8'})
object:addAttributes({attribute_domain, attribute_ip})

object:addReference(attribute, 'test-reference')

event:addAttribute(attribute)
event:addObject(object)

print(event:toJson())
```
