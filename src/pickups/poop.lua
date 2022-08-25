SPR_POOP_1 = 11
SPR_POOP_2 = 12
SPR_POOP_3 = 13
SPR_POOP_4 = 14

local poopsTable = {}
local animData = {
    name = "IDLE",
    sprites = {
        SPR_POOP_1,
        SPR_POOP_2,
        SPR_POOP_3,
        SPR_POOP_4
    },
    interval = 0.25
}
local previousStartSpriteIdx = 0
local lastPoopId = 0

local function getPoopIdx(id)
    for i=1,#poopsTable do
        if poopsTable[i].id == id then
            return i
        end
    end

    return 0
end

function GetNumOfPoops()
    return #poopsTable
end

function GetPoop(id)
    for i=1,#poopsTable do
        if poopsTable[i].id == id then
            return poopsTable[i]
        end
    end

    return nil
end

function DrawAllPoops()
    for i=1,#poopsTable do
        if poopsTable[i] then
            DrawPoop(poopsTable[i].id)
        end
    end
end

function UpdateAllPoops()
    for i=1,#poopsTable do
        if poopsTable[i] then
            UpdatePoop(poopsTable[i].id)
        end
    end
end

function GetAllPoops()
    local poops = {}

    for i = 1,#poopsTable do
        if poopsTable[i] then
            local poop = poopsTable[i]
            poops[#poops + 1] = poop
        end
    end

    return poops
end

function AddPoop(cellX, cellY)
    local poop = {
        id = 0,
        attributes = {}
    }

    poop.id = lastPoopId + 1
    poop.attributes = CreatePikcup()

    poop.attributes.p.x = cellX * 8
    poop.attributes.p.y = cellY * 8
    poop.attributes.h = 8
    poop.attributes.w = 8
    poop.attributes.currentSprite = animData.sprites[1]
    poop.attributes.hitbox.x = 2
    poop.attributes.hitbox.y = 2
    poop.attributes.hitbox.w = 4
    poop.attributes.hitbox.h = 4
    poop.attributes.animationStart = time()

    poopsTable[#poopsTable + 1] = poop
    previousStartSpriteIdx = (previousStartSpriteIdx + 1) % #animData.sprites
    lastPoopId = lastPoopId + 1
end

function DrawPoop(id)
    local poop = GetPoop(id)

    if poop == nil then
        return
    end

    spr(
        poop.attributes.currentSprite,
        poop.attributes.p.x,
        poop.attributes.p.y,
        poop.attributes.w / 8,
        poop.attributes.h / 8
    )
end

local function animatePoop(id)
    local poop = GetPoop(id)

    if poop == nil then
        return
    end

    if time() - poop.attributes.animationStart > animData.interval then
        local nextSpriteIdx = poop.attributes.currentSprite - 11

        poop.attributes.currentSprite = animData.sprites[((nextSpriteIdx + 1) % #animData.sprites) + 1]
        poop.attributes.animationStart = time()
    end
end

function UpdatePoop(id)
    local poop = GetPoop(id)

    if poop == nil then
        return
    end

    animatePoop(poop.id)

    if
        ObjectsOverlapping(
            poop.attributes,
            Player:getCollisionData()
        )
    then
        Player:incrementPoops(1)
        DestroyPoop(poop.id)
    end
end

function DestroyPoop(id)
    local idx = getPoopIdx(id)

    if idx == 0 then
        return
    end

    deli(poopsTable, idx)
end
