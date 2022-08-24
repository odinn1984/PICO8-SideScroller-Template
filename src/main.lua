APPID="01341039-e93b-435b-8829-29cb6be5e3ee"

function _init()
	cartdata(APPID)

	for cy=0,64 do
		for cx=0,64 do
			local clearCell = false
			local curCell = mget(cx, cy)

			if curCell == SPR_COIN_1 then
				clearCell = true;
				AddCoin(cx, cy)
			elseif curCell == SPR_SPIKE_H or curCell == SPR_SPIKE_H_FLIP_X then
				local flag = fget(curCell)

				clearCell = true;

				if flag == 0x81 then
					AddSpike(cx, cy, false, true, true)
				else
					AddSpike(cx, cy, false, false, true)
				end
			elseif curCell == SPR_SPIKE_V or curCell == SPR_SPIKE_V_FLIP_Y then
				local flag = fget(curCell)

				clearCell = true;

				if flag == 0x81 then
					AddSpike(cx, cy, false, true, false)
				else
					AddSpike(cx, cy, false, false, false)
				end
			elseif curCell == 46 then
				clearCell = true;
				Player:init({ celX=cx, celY=cy }, DIRECTION_RIGHT)
			elseif curCell == 62 then
				clearCell = true;
				Player:init({ celX=cx, celY=cy }, DIRECTION_LEFT)
			end

			if clearCell == true then
				mset(cx, cy, 16)
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
