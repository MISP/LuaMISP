local utils = require 'utils'

----------------------------------------
-- AbstractMISP
AbstractMISP = {}

function AbstractMISP:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function AbstractMISP:toJson()
    return utils.jsonEncode(self)
end

function AbstractMISP:addTag(tagname)
    table.insert(self.Tag, {
        name = tagname
    })
end

function AbstractMISP:addTags(tags)
    for i, tag in ipairs(tags) 
    do
        self:addTag(tag)
    end
end

----------------------------------------
-- Event
Event = AbstractMISP:new()
function Event:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    if not o.uuid then
        o.uuid = utils.uuid()
    end
    if not o.Tag then
        o.Tag = {}
    end
    if not o.Attribute then
        o.Attribute = {}
    end
    if not o.Object then
        o.Object = {}
    end
    return o
end
function Event:__tostring()
    return string.format('<Event title="%s" Attribute=%s Object=%s>', self.title, #self.Attribute, #self.Object)
end
function Event:fullToString()
    local output = tostring(self)
    for i, object in ipairs(self.Object) do
        output = output .. '\n\t' .. object:fullToString()
    end
    for i, attribute in ipairs(self.Attribute) do
        output = output .. '\n\t' .. tostring(attribute)
    end
    return output
end


function Event:addAttribute(attribute)
    if attribute ~= nil then
        table.insert(self.Attribute, attribute)
    end
end

function Event:addAttributes(attributes)
    for i, attribute in ipairs(attributes)
    do
        self:addAttribute(attribute)
    end
end

function Event:addObject(object)
    if object ~= nil then
        table.insert(self.Object, object)
    end
end

function Event:addObjects(objects)
    for i, object in ipairs(objects)
    do
        self:addObject(object)
    end
end

----------------------------------------
-- Attribute
Attribute = AbstractMISP:new()
function Attribute:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    if not o.uuid then
        o.uuid = utils.uuid()
    end
    if not o.Tag then
        o.Tag = {}
    end
    if o.data then
        o.data = utils.base64.encode(o.data)
    end

    if o.type ~= nil and o.value ~= nil then
        return o
    else
        return nil
    end
end
function Attribute:__tostring()
    return string.format('<Attribute type="%s" value="%s">', self.type, self.value)
end
function Attribute:fullToString()
    return tostring(self)
end


----------------------------------------
-- Object
-- /!\ Current limitation: Do not support object-template. You have to supply the object-template data when creating the object
Object = AbstractMISP:new()
function Object:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    if not o.uuid then
        o.uuid = utils.uuid()
    end
    if not o.Attribute then
        o.Attribute = {}
    end
    if not o.ObjectReference then
        o.ObjectReference = {}
    end
    return o
end
function Object:__tostring()
    return string.format('<Object name="%s" Attribute=%s Reference=%s>', self.name, #self.Attribute, #self.ObjectReference)
end
function Object:fullToString()
    local output = tostring(self)
    for i, attribute in ipairs(self.Attribute) do
        output = output .. '\n\t\t' .. tostring(attribute)
    end
    return output
end



function Object:addAttribute(attribute)
    if attribute ~= nil then
        table.insert(self.Attribute, attribute)
    end
end

function Object:addAttributes(attributes)
    for i, attribute in ipairs(attributes)
    do
        self:addAttribute(attribute)
    end
end

function Object:addReference(attribute, type)
    local reference = {
        uuid = utils.uuid(),
        object_uuid = self.uuid,
        referenced_uuid = attribute.uuid,
        relationship_type = type,
    }
    table.insert(self.ObjectReference, reference)
end

function Object:getAttributeByName(attribute_name)
    for i, attribute in ipairs(self.Attribute) do
        if attribute.object_relation == attribute_name then
            return attribute
        end
    end
    return nil
end
