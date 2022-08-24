function CorrectPlayerPosition(playerState)
    local bottomOverflow = playerState.p.y - flr(playerState.p.y)

    playerState.p.y = playerState.p.y - bottomOverflow
    playerState.p.y = playerState.p.y - ((playerState.p.y + playerState.h) % 8)
    playerState.v.y = 0
end
