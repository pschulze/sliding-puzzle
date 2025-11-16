-- marker --

MARKER_SPRITE = 64

function Marker_init()
	return {
		x = 0,
		y = 0,
	}
end

function Marker_update(marker)
	if btnp(BTN_X) or btnp(BTN_O) then
		Marker_activate(marker, State.board)
	end

	local moves = {}
	if btnp(BTN_LEFT) then
		add(moves, BOARD_MOVE_LEFT)
	elseif btnp(BTN_RIGHT) then
		add(moves, BOARD_MOVE_RIGHT)
	end

	if btnp(BTN_UP) then
		add(moves, BOARD_MOVE_UP)
	elseif btnp(BTN_DOWN) then
		add(moves, BOARD_MOVE_DOWN)
	end

	Marker_move(marker, moves)
end

function Marker_draw(marker)
	spr(MARKER_SPRITE, marker.x, marker.y, 2, 2)
end

function Marker_move(marker, moves)
	local moved = false

	for _, move in ipairs(moves) do
		if Marker_can_move(marker, move) then
			moved = true
			marker.x = marker.x + (move.j * BOARD_C_SIZE)
			marker.y = marker.y + (move.i * BOARD_C_SIZE)
		end
	end

	return moved
end

function Marker_activate(marker, board)
	-- Get board zero pos, iterate over available_moves, apply move to it, if it matches marker coords then swap
	local zero_pos = Board_zero_position(board)
	local marker_pos = Marker_coordinates(marker)
	for _, move in ipairs(Board_available_moves(board)) do
		local target_i = zero_pos.i + move.i
		local target_j = zero_pos.j + move.j
		if target_i == marker_pos.i and target_j == marker_pos.j then
			Board_make_move(board, move)
			return true
		end
	end

	-- change colour to green briefly to indicate successful move
	-- change colour to red briefly to indicate unsuccessful move
end

-- Return a boolean indicating if the marker can move in the specified direction
function Marker_can_move(marker, move)
	local new_x = marker.x + (move.j * BOARD_C_SIZE)
	local new_y = marker.y + (move.i * BOARD_C_SIZE)

	return new_x >= 0
		and new_x < (BOARD_C_SIZE * #BOARD_STATE_SOLVED)
		and new_y >= 0
		and new_y < (BOARD_C_SIZE * #BOARD_STATE_SOLVED[1])
end

function Marker_coordinates(marker)
	return {
		i = (marker.y / BOARD_C_SIZE) + 1,
		j = (marker.x / BOARD_C_SIZE) + 1,
	}
end
