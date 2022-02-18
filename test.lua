local LuaMISP = require 'LuaMISP'

local f = assert(io.open("test.lua", "rb"))
local bytes = f:read("*all")
local attribute_attachment = Attribute:new({type='attachment', value='filename', data=bytes})
assert(attribute_attachment.value == 'filename')

local event = Event:new({title='Test event from LuaMISP'})
assert(event.title == 'Test event from LuaMISP')
event:addTags({'tag1', 'tag2'})
assert(event.Tag[2].name == 'tag2') -- Table index start at 1 in Lua

local object = Object:new({type='domain-ip'})
assert(object.type == 'domain-ip')
local attribute_domain = Attribute:new({type='domain', value='google.com'})
local attribute_ip = Attribute:new({type='ip', value='8.8.8.8'})
object:addAttributes({attribute_domain, attribute_ip})
assert(object.Attribute[1].value == 'google.com')

object:addReference(attribute_attachment, 'test-reference')
assert(object.ObjectReference[1].relationship_type == 'test-reference')
assert(object.ObjectReference[1].object_uuid == object.uuid)
assert(object.ObjectReference[1].referenced_uuid == attribute_attachment.uuid)


event:addAttribute(attribute)
event:addObject(object)
local eventJson = event:toJson()
assert(type(eventJson) == 'string')
