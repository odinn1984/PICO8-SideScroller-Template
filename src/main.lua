APPID="01341039-e93b-435b-8829-29cb6be5e3ee"

function _init()
	cartdata(APPID)

	for cy=0,64 do
		for cx=0,64 do
			local clearCell = false
			local curCell = mget(cx, cy)

			if curCell == SPR_POOP_1 then
				clearCell = true;
				AddPoop(cx, cy)
			elseif curCell == SPR_SPIKE_H or curCell == SPR_SPIKE_H_FLIP_Y then
				clearCell = true;
				AddSpike(cx, cy, false, curCell == SPR_SPIKE_H_FLIP_Y, true)
			elseif curCell == SPR_SPIKE_V or curCell ==  SPR_SPIKE_V_FLIP_X then
				clearCell = true;
				AddSpike(cx, cy, curCell ==  SPR_SPIKE_V_FLIP_X, false, false)
			elseif curCell == SPR_PLAYER_START_RIGHT then
				clearCell = true;
				Player:init({ celX=cx, celY=cy }, DIRECTION_RIGHT)
			elseif curCell == SPR_PLAYER_START_LEFT then
				clearCell = true;
				Player:init({ celX=cx, celY=cy }, DIRECTION_LEFT)
			end

			if clearCell == true then
				mset(cx, cy, rnd({SPR_BG_1, SPR_BG_2}))
			end
		end
	end
end

function _update60()
	GameUpdate()
end

function _draw()
	GameDraw()
end
