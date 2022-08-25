SPR_SPIKE_H = 15
SPR_SPIKE_H_FLIP_Y = 47
SPR_SPIKE_V = 31
SPR_SPIKE_V_FLIP_X = 63

local spikesTable = {}

function GetNumOfspikes()
    return #spikesTable
end

function GetSpike(id)
    return spikesTable[id]
end

function DrawAllSpikes()
    for i = 1,#spikesTable do
        DrawSpike(i)
    end
end

function UpdateAllSpikes()
    for i = 1,#spikesTable do
        UpdateSpike(i)
    end
end

function AddSpike(cellX, cellY, flipX, flipY, horizontal)
    local spike = {
        id = 0,
        attributes = {}
    }

    spike.id = #spikesTable + 1
    spike.attributes = CreateHazzard()

    spike.attributes.p.x = cellX * 8
    spike.attributes.p.y = cellY * 8

    if horizontal then
        if flipY then
            spike.attributes.hitbox.x = 1
            spike.attributes.hitbox.y = 0
            spike.attributes.currentSprite = SPR_SPIKE_H_FLIP_Y
        else
            spike.attributes.hitbox.x = 1
            spike.attributes.hitbox.y = 4
            spike.attributes.currentSprite = SPR_SPIKE_H
        end

        spike.attributes.hitbox.w = 6
        spike.attributes.hitbox.h = 2
    else
        if flipX then
            spike.attributes.hitbox.x = 0
            spike.attributes.hitbox.y = 1
            spike.attributes.currentSprite = SPR_SPIKE_V_FLIP_X
        else
            spike.attributes.hitbox.x = 4
            spike.attributes.hitbox.y = 1
            spike.attributes.currentSprite = SPR_SPIKE_V
        end

        spike.attributes.hitbox.w = 2
        spike.attributes.hitbox.h = 6
    end

    spikesTable[spike.id] = spike
end

function DrawSpike(id)
    local spike = spikesTable[id]

    spr(
        spike.attributes.currentSprite,
        spike.attributes.p.x,
        spike.attributes.p.y,
        spike.attributes.w / 8,
        spike.attributes.h / 8
    )
end

function UpdateSpike(id)
    if
        ObjectsOverlapping(
            spikesTable[id].attributes,
            Player:getCollisionData()
        )
    then
        Player:takeDamage()
    end
end
