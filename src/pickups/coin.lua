SPR_COIN_1 = 11
SPR_COIN_2 = 12
SPR_COIN_3 = 13
SPR_COIN_4 = 14

local coinsTable = {}
local animData = {
    name = "IDLE",
    sprites = {
        SPR_COIN_1,
        SPR_COIN_2,
        SPR_COIN_3,
        SPR_COIN_4
    },
    interval = 0.5
}
local previousStartSpriteIdx = 0
local lastCoinId = 0

local function getCoinIdx(id)
    for i=1,#coinsTable do
        if coinsTable[i].id == id then
            return i
        end
    end

    return 0
end

function GetNumOfCoins()
    return #coinsTable
end

function GetCoin(id)
    for i=1,#coinsTable do
        if coinsTable[i].id == id then
            return coinsTable[i]
        end
    end

    return nil
end

function DrawAllCoins()
    for i=1,#coinsTable do
        if coinsTable[i] then
            DrawCoin(coinsTable[i].id)
        end
    end
end

function UpdateAllCoins()
    for i=1,#coinsTable do
        if coinsTable[i] then
            UpdateCoin(coinsTable[i].id)
        end
    end
end

function GetAllCoins()
    local coins = {}

    for i = 1,#coinsTable do
        if coinsTable[i] then
            local coin = coinsTable[i]
            coins[#coins + 1] = coin
        end
    end

    return coins
end

function AddCoin(cellX, cellY)
    local coin = {
        id = 0,
        attributes = {}
    }

    coin.id = lastCoinId + 1
    coin.attributes = CreatePikcup()

    coin.attributes.p.x = cellX * 8
    coin.attributes.p.y = cellY * 8
    coin.attributes.h = 8
    coin.attributes.w = 8
    coin.attributes.currentSprite = animData.sprites[1]
    coin.attributes.hitbox.x = 2
    coin.attributes.hitbox.y = 2
    coin.attributes.hitbox.w = 4
    coin.attributes.hitbox.h = 4
    coin.attributes.animationStart = time()

    coinsTable[#coinsTable + 1] = coin
    previousStartSpriteIdx = (previousStartSpriteIdx + 1) % #animData.sprites
    lastCoinId = lastCoinId + 1
end

function DrawCoin(id)
    local coin = GetCoin(id)

    if coin == nil then
        return
    end

    spr(
        coin.attributes.currentSprite,
        coin.attributes.p.x,
        coin.attributes.p.y,
        coin.attributes.w / 8,
        coin.attributes.h / 8
    )
end

local function animateCoin(id)
    local coin = GetCoin(id)

    if coin == nil then
        return
    end

    if time() - coin.attributes.animationStart > animData.interval then
        local nextSpriteIdx = coin.attributes.currentSprite - 11

        coin.attributes.currentSprite = animData.sprites[((nextSpriteIdx + 1) % #animData.sprites) + 1]
        coin.attributes.animationStart = time()
    end
end

function UpdateCoin(id)
    local coin = GetCoin(id)

    if coin == nil then
        return
    end

    animateCoin(coin.id)

    if
        ObjectsOverlapping(
            coin.attributes,
            Player:getCollisionData()
        )
    then
        Player:incrementCoins(1)
        DestroyCoin(coin.id)
    end
end

function DestroyCoin(id)
    local idx = getCoinIdx(id)

    if idx == 0 then
        return
    end

    deli(coinsTable, idx)
end
