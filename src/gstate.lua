STATE_MAIN_MENU = 0
STATE_GAME_PAUSE = 1
STATE_GAME_LOOP = 2
STATE_GAME_DIALOG = 3
STATE_GAME_WIN = 4
STATE_GAME_OVER = 5

local currentState = STATE_GAME_LOOP

function GetGameState()
    return currentState
end

function SetGameState(newState)
    currentState = newState
end

local function gameLoopUpdate()
    UpdatePickups()
	UpdateHazzards()

    Player:update()
end

local function gameLoopDraw()
    cls()

    camera(Player:getPosition().x - 64, 0)

    map(0, 0, 0, 0, 32, 16)

    DrawPickups()
	DrawHazzards()

    Player:draw()
end

function GameUpdate()
    if currentState == STATE_GAME_LOOP then
        gameLoopUpdate()
    end
end

function GameDraw()
    if currentState == STATE_GAME_LOOP then
        gameLoopDraw()
    end
end
