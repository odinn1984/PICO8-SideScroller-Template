FLAG_BLOCK = 0
FLAG_TRIGGER = 1
FLAG_PLAYER = 6
FLAG_ENEMY = 7

local CHK_DIRECTION_UP = "UP"
local CHK_DIRECTION_DOWN = "DOWN"
local CHK_DIRECTION_LEFT = "LEFT"
local CHK_DIRECTION_RIGHT = "RIGHT"

local function collidingWithCelInDirection(obj, objHitbox, dir)
    local hitbox = {
        { x=0, y=0 },
        { x=0, y=0 },
        { x=0, y=0 }
    }

    local objX = obj.p.x + objHitbox.x
    local objY = obj.p.y + objHitbox.y
    local objW = objHitbox.w - 1
    local objH = objHitbox.h - 1

    if dir == CHK_DIRECTION_LEFT then
        hitbox[1].x = objX
        hitbox[1].y = objY + 2
        hitbox[2].x = objX - 1
        hitbox[2].y = objY + (objH / 2)
        hitbox[3].x = objX - 2
        hitbox[3].y = objY + objH - 2
    elseif dir == CHK_DIRECTION_RIGHT then
        hitbox[1].x = objX + objW - 1
        hitbox[1].y = objY + 2
        hitbox[2].x = objX + objW
        hitbox[2].y = objY + (objH / 2)
        hitbox[3].x = objX + objW + 1
        hitbox[3].y = objY + objH - 2
    elseif dir == CHK_DIRECTION_DOWN then
        hitbox[1].x = objX
        hitbox[1].y = objY + objH - 1
        hitbox[2].x = objX + (objW / 2)
        hitbox[2].y = objY + objH
        hitbox[3].x = objX + objW
        hitbox[3].y = objY + objH + 1
    elseif dir == CHK_DIRECTION_UP then
        hitbox[1].x = objX
        hitbox[1].y = objY + 1
        hitbox[2].x = objX + (objW / 2)
        hitbox[2].y = objY
        hitbox[3].x = objX + objW
        hitbox[3].y = objY - 1
    end

    for i=1,3 do
        for j=1,3 do
            if fget(mget(flr((hitbox[i].x) / 8), flr(hitbox[j].y / 8)), FLAG_BLOCK) then
                return true
            end
        end
    end

    return false
end

function CollidingWithCelOnRight(obj)
    return collidingWithCelInDirection(obj, obj.hitbox, CHK_DIRECTION_RIGHT)
end

function CollidingWithCelOnLeft(obj)
    return collidingWithCelInDirection(obj, obj.hitbox, CHK_DIRECTION_LEFT)
end

function CollidingWithCelOnTop(obj)
    return collidingWithCelInDirection(obj, obj.hitbox, CHK_DIRECTION_UP)
end

function CollidingWithCelOnBottom(obj)
    return collidingWithCelInDirection(obj, obj.hitbox, CHK_DIRECTION_DOWN)
end

function ObjectsOverlapping(obj, otherObj)
    local hitbox = {
        {
            x = obj.p.x + obj.hitbox.x,
            y = obj.p.y + obj.hitbox.y
        },
        {
            x=obj.p.x + obj.hitbox.x + obj.hitbox.w,
            y=obj.p.y + obj.hitbox.y + obj.hitbox.h
        }
    }

    local otherHitbox = {
        {
            x = otherObj.p.x + otherObj.hitbox.x,
            y = otherObj.p.y + otherObj.hitbox.y
        },
        {
            x=otherObj.p.x + otherObj.hitbox.x + otherObj.hitbox.w,
            y=otherObj.p.y + otherObj.hitbox.y + otherObj.hitbox.h
        }
    }

    return RectsOverlap(hitbox, otherHitbox)
end
