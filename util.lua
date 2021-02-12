
enableTouch = true

function toBits(num)
    local t = {}
	
    while num > 0 do
        rest = math.fmod(num, 2)
        t[#t + 1] = rest
        num = (num - rest) / 2
    end

    local final = {}

    for i = 1, 18 - #t do
        final[i] = 0
    end

    for i = #t, 1, -1 do
        final[19 - i] = math.floor(t[i])
    end

    return final
end

function makeSprite(parent)
	local sprite = Sprite.new()
	
	parent:addChild(sprite)
	
	return sprite
end

function Sprite:onTouch(func)
	self.__onTouchListener = func
	
	if not self.__isAddedOnTouch then
		self.__isAddedOnTouch = true
		
		self.__onTouchListenerWrapper = function(event)
			if self.blockTouch then
				event:stopPropagation()
				return
			end
			
			if self:getAlpha() > 0 and enableTouch and self:hitTestPoint(event.x, event.y) then
				self.__onTouchListener(event.x, event.y)
				event:stopPropagation()
			end
		end
		
		self:addEventListener(Event.MOUSE_DOWN, self.__onTouchListenerWrapper)
	end

end

local emptyObj = {
	get = function(obj) end,
	set = function(obj, val) end
}

function wait(delay, callback)
	GTween.new(emptyObj, delay, {}, {
		onComplete = callback
	})
end

function firstToUpper(str)
    return str:gsub("^%l", string.upper)
end

function Sprite:onFrame(func)
	self.__onFrameListener = func
	
	if not self.__isAddedOnFrame then
		self.__isAddedOnFrame = true
		
		self.__onFrameListenerWrapper = function()
			self.__onFrameListener()
		end
		
		self:addEventListener(Event.ENTER_FRAME, self.__onFrameListenerWrapper)
	end
end

function Sprite:del()
	if self.__isAddedOnFrame then
		self.__isAddedOnFrame = nil
		self:removeEventListener(Event.ENTER_FRAME, self.__onFrameListenerWrapper)
	end
	
	if self.__isAddedOnTouch then
		self.__isAddedOnTouch = nil
		self:removeEventListener(Event.MOUSE_DOWN, self.__onTouchListenerWrapper)
	end
	
	self:removeFromParent()
end

local textures = {}

function preload(img)
	textures[img] = Texture.new("images/"..img..".png")
end

local preloads = {
    "dialog",
	"circle_cancel",
	"circle_play",
	"block_poison",
	"block_health",
	"block_flame",
	"block_attack"
}

for _, p in pairs(preloads) do
	preload(p)
end

function makeImage(parent, image)
	if textures[image] == nil then
		textures[image] = Texture.new("images/"..image..".png")
	end
	
	local sprite = Bitmap.new(textures[image])
	parent:addChild(sprite)
	
	sprite.setImage = function(img)
		if textures[img] == nil then
			textures[img] = Texture.new("images/"..img..".png")
		end
		
		sprite:setTexture(textures[img])
	end
	
	return sprite
end

function makeCharacter(parent, image)
	local sprite = Bitmap.new(Texture.new("characters/"..image..".png"))
	parent:addChild(sprite)
	
	sprite.setCharacter = function(char)
		sprite:setTexture(Texture.new("characters/"..char..".png"))
	end
	
	return sprite
end

local _get = Sprite.get

function Sprite:get(param)
	if param == "clipWidth" then
		return self.__clipWidth or 0
	end
	
	return _get(self, param)
end

local _set = Sprite.set

function Sprite:set(param, value)
	if param == "clipWidth" then
		self.__clipWidth = value
		self:setClip(0, 0, value, self:getHeight() / self:getScaleY())
	else
		_set(self, param, value)
	end
end

function formatComma(i)
  return tostring(i):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end


