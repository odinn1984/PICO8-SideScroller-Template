local SPR_IDLE = 64
local SPR_STEP_1 = 65
local SPR_STEP_2 = 66
local SPR_JUMP = 67
local SPR_FALL = 68
local SPR_INVINCIBLE = 69

local PLAYER_INVINCIBLE = { name = "INVINCIBLE", sprites = { SPR_IDLE, SPR_INVINCIBLE }, interval = 0.15 }
local PLAYER_IDLE = { name = "IDLE", sprites = { SPR_IDLE }, interval = 0 }
local PLAYER_WALK = { name = "WALK", sprites = { SPR_STEP_1, SPR_STEP_2 }, interval = 0.15 }
local PLAYER_JUMP = { name = "JUMP", sprites = { SPR_JUMP }, interval = 0 }
local PLAYER_FALL = { name = "FALL", sprites = { SPR_FALL }, interval = 0 }

Player = {}

function Player:init(spawn, direction)
    Player.attributes = {
        p = {
            x = spawn.celX * 8,
            y = spawn.celY * 8
        },

        prevP = {
            x = spawn.celX * 8,
            y = spawn.celY * 8
        },

        spawn = {
            x = spawn.celX * 8,
            y = spawn.celY * 8
        },

        v = {
            x = 0,
            y = 0
        },

        maxSpeed = 1,
        jumpForce = 3,
        coyoteTimeStart = 0.0,
        coyoteTime = 0.1,
        jumpBufferStart = 0.0,
        jumpBuffer = 0.15,
        jumpRequested = false,
        stopJumpGravityMultiplier = 3,
        canPressJump = true,
        fallSpeed = 2,
        originalGravity = 0.21,
        maxGravity = 0.21,

        w = 8,
        h = 8,

        hitbox = {
            x = 2,
            y = 0,
            w = 4,
            h = 8
        },

        isJumping = false,
        isFalling = false,
        onGround = false,
        canMove = false,

        direction = direction,
        currentSprite = PLAYER_IDLE.sprites[1],
        animState = PLAYER_IDLE,
        animStart = 0,

        invincible = true,
        invincibleDuration = 1,
        invincibleStart = time(),

        coins = 0,
        points = 0,
    }
end

function Player:getPosition()
    return {
        x = self.attributes.p.x,
        y = self.attributes.p.y
    }
end

function Player:getSpawnPosition()
    return {
        x = self.attributes.spawn.x,
        y = self.attributes.spawn.y
    }
end

function Player:getDimension()
    return {
        w = self.attributes.w,
        h = self.attributes.h
    }
end

function Player:getHitbox()
    return self.attributes.hitbox
end

function Player:getVelocity()
    return self.attributes.v
end

function Player:getCollisionData()
    return {
        p = self.attributes.p,
        w = self.attributes.w,
        h = self.attributes.h,
        hitbox = self.attributes.hitbox
    }
end

function Player:draw()
    self:drawSprites()
end

function Player:update()
    if self.attributes.canMove then
        self:updateYMovement()
        self:updateXMovement()
    end

    self:animate()

    if time() - self.attributes.invincibleStart >= self.attributes.invincibleDuration then
        self.attributes.invincible = false
        self.attributes.canMove = true
    end
end

function Player:updateXMovement()
    if btn(BUTTON_RIGHT) and not btn(BUTTON_LEFT) then
        self.attributes.direction = DIRECTION_RIGHT
        self.attributes.v.x = self.attributes.maxSpeed
    elseif btn(BUTTON_LEFT) and not btn(BUTTON_RIGHT) then
        self.attributes.direction = DIRECTION_LEFT
        self.attributes.v.x = -self.attributes.maxSpeed
    else
        self.attributes.v.x = 0
    end

    self.attributes.p.x = self.attributes.p.x + self.attributes.v.x

    if
        (self.attributes.direction == DIRECTION_LEFT and CollidingWithCelOnLeft(self.attributes)) or
        (self.attributes.direction == DIRECTION_RIGHT and CollidingWithCelOnRight(self.attributes))
    then
        self.attributes.p.x = self.attributes.prevP.x
    end

    self.attributes.prevP.x = self.attributes.p.x
end

function Player:updateYMovement()
    self.attributes.onGround = CollidingWithCelOnBottom(self.attributes)

    local gravity =
        abs(self.attributes.v.y) > 0.15 and
            self.attributes.maxGravity or (self.attributes.maxGravity)

    if self.attributes.v.y > 0 then
        self.attributes.isFalling = true
        self.attributes.onGround = false

        if self.attributes.coyoteTimeStart == 0.0 and not self.attributes.isJumping then
            self.attributes.coyoteTimeStart = time()
        end

        if CollidingWithCelOnBottom(self.attributes) then
            self.attributes.isJumping = false
            self.attributes.isFalling = false
            self.attributes.onGround = true
            self.attributes.coyoteTimeStart = 0.0

            CorrectPlayerPosition(self.attributes)

            if self.attributes.jumpRequested and time() - self.attributes.jumpBufferStart < self.attributes.jumpBuffer then
                self.attributes.v.y = -self.attributes.jumpForce
                self.attributes.isJumping = true
            end

            self.attributes.jumpRequested = false
            self.attributes.maxGravity = self.attributes.originalGravity
        end
    elseif self.attributes.v.y < 0 then
        self.attributes.isJumping = true
        self.attributes.onGround = false
        self.attributes.coyoteTimeStart = 0.0
    else
        self.attributes.isJumping = false
        self.attributes.isFalling = false
        self.attributes.coyoteTimeStart = 0.0
        self.attributes.onGround = CollidingWithCelOnBottom(self.attributes)

        if self.attributes.jumpRequested and time() - self.attributes.jumpBufferStart < self.attributes.jumpBuffer then
            self.attributes.v.y = -self.attributes.jumpForce
            self.attributes.isJumping = true
        end

        self.attributes.jumpRequested = false
        self.attributes.maxGravity = self.attributes.originalGravity
    end

    if not self.attributes.onGround then
        self.attributes.v.y = Approach(
            self.attributes.v.y,
            self.attributes.fallSpeed,
            gravity
        )
    end

    if (btn(BUTTON_O) or btn(BUTTON_UP)) then
        if self.attributes.canPressJump then
            self.attributes.maxGravity = self.attributes.originalGravity

            if self.attributes.isFalling then
                self.attributes.jumpBufferStart = time()
                self.attributes.jumpRequested = true
            end

            self.attributes.canPressJump = false

            if
            (
                (
                    not self.attributes.isJumping and
                    not self.attributes.isFalling
                )
                or
                (
                    self.attributes.isFalling and
                    self.attributes.coyoteTimeStart > 0.0 and
                    time() - self.attributes.coyoteTimeStart < self.attributes.coyoteTime
                )
            )
            then
                self.attributes.jumpRequested = false
                self.attributes.v.y = -self.attributes.jumpForce
                self.attributes.isJumping = true
            end
        end
    else
        self.attributes.maxGravity = self.attributes.originalGravity * self.attributes.stopJumpGravityMultiplier

        self.attributes.canPressJump = true
    end

    self.attributes.p.y = self.attributes.p.y + self.attributes.v.y

    if
        self.attributes.v.y < 0 and CollidingWithCelOnTop(self.attributes)
    then
        self.attributes.p.y = self.attributes.prevP.y
        self.attributes.v.y = Approach(
            self.attributes.v.y,
            self.attributes.fallSpeed,
            gravity
        )
    end

    self.attributes.prevP.y = self.attributes.p.y
end

function Player:updateAnimState()
    local newAnimState = PLAYER_IDLE
    local onGround = not self.attributes.isFalling and not self.attributes.isJumping

    if self.attributes.invincible then
        newAnimState = PLAYER_INVINCIBLE
    else
        if abs(self.attributes.v.x) > 0 and onGround then
            newAnimState = PLAYER_WALK
        elseif self.attributes.v.y > 0 then
            newAnimState = PLAYER_FALL
        elseif self.attributes.v.y < 0 then
            newAnimState = PLAYER_JUMP
        end
    end

    if newAnimState.name ~= self.attributes.animState.name then
        self.attributes.animStart = time()
        self.attributes.animState = newAnimState
        self.attributes.currentSprite = newAnimState.sprites[1]
    end
end

function Player:animate()
    self:updateAnimState()

    local animState = self.attributes.animState
    local numOfSprites = #(animState.sprites)
    local currentSpriteIndex = FindIndexFromZero(animState.sprites, self.attributes.currentSprite)

    if
        animState.interval > 0 and
        time() - self.attributes.animStart >= animState.interval and
        currentSpriteIndex >= 0
    then
        local nextSpriteIndex = (currentSpriteIndex + 1) % numOfSprites

        self.attributes.animStart = time()
        self.attributes.currentSprite = animState.sprites[nextSpriteIndex + 1]
    end
end

function Player:drawSprites()
    local flipSprite = self.attributes.direction == DIRECTION_LEFT and true or false

    spr(
        self.attributes.currentSprite,
        self.attributes.p.x,
        self.attributes.p.y,
        self.attributes.w / 8,
        self.attributes.h / 8,
        flipSprite
    )
end

function Player:takeDamage()
    if
        not self.attributes.invincible and
        not self:isDead()
    then
        FadeOut()
        Wait(20)
        pal()

        self:respawn()
    end
end

function Player:isDead()
    return false
end

function Player:respawn()
    self.attributes.invincible = true
    self.attributes.invincibleStart = time()
    self.attributes.canMove = false

    self.attributes.p.x = self.attributes.spawn.x
    self.attributes.p.y = self.attributes.spawn.y
    self.attributes.v.x = 0
    self.attributes.v.y = 0
    self.attributes.prevP.x = self.attributes.spawn.x
    self.attributes.prevP.y = self.attributes.spawn.y
    self.attributes.direction = DIRECTION_RIGHT
end

function Player:incrementCoins(val)
    if val > 0 then
        self.attributes.coins = self.attributes.coins + val

        if self.attributes.coins >= 100 then
            self.attributes.coins = 0
            self.attributes.currentLives = self.attributes.currentLives + 1
        end
    end
end

function Player:incrementPoints(val)
    if val > 0 then
        self.attributes.points = self.attributes.points + val
    end
end

function Player:getDirection()
    return self.attributes.direction
end
