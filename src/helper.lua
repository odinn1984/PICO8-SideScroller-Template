function Approach(val, target, amount)
    return val > target
 	    and max(val - amount, target)
 	    or min(val + amount, target)
end

function Sign(num)
	return num > 0 and 1 or
			num < 0 and -1 or 0
end

function Round(num, decimalPlaces)
    local mult = 10^(decimalPlaces or 0)
    return flr(num * mult + 0.5) / mult
end

function FindIndexFromZero(table, val)
	for i=1,#table do
		if table[i] == val then
			return i-1
		end
	end

	return -1
end

function RectsOverlap(rect, otherRect)
	return
		rect[1].x < otherRect[2].x and
		rect[2].x > otherRect[1].x and
		rect[1].y < otherRect[2].y and
		rect[2].y > otherRect[1].y
end

function Wait(t)
    for i = 1,t do flip() end
end

local function shouldTrim(char)
	return
		char == "\n" or
		char == "\r" or
		char == "\b" or
		char == "\t" or
		char == " "
end

function TrimLeft(text)
	local start = 1
	local trimming = true

	while trimming do
		if not shouldTrim(chr(ord(text, start))) then
			trimming = false
		end

		start = start + 1
	end

	return sub(text, start)
end

function TrimRight(text)
	local strend = #text
	local trimming = true

	while trimming do
		if not shouldTrim(chr(ord(text, strend))) then
			trimming = false
		end

		strend = strend - 1
	end

	return sub(text, 1, strend)
end

function Trim(text)
	return TrimRight(TrimLeft(text))
end

function FadeOut()
	local dpal = {0,1,1,2,1,13,6,4,4,9,3,13,1,13,14}

	for i=0,40 do
		for j=1,15 do
			local col = j

			for k=1,((i+(j%5))/4) do
				col = dpal[col]
			end

			pal(j, col, 1)
		end

		flip()
	end
end
