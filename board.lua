-- board --

BOARD_C_SIZE = 16
BOARD_VAL_SPRITE_MAP = { 2, 4, 6, 8, 10, 12, 14, 32, 34, 36, 38, 40, 42, 44, 46 }

BOARD_MOVE_RIGHT = { i = 0, j = 1 }
BOARD_MOVE_LEFT = { i = 0, j = -1 }
BOARD_MOVE_UP = { i = -1, j = 0 }
BOARD_MOVE_DOWN = { i = 1, j = 0 }

BOARD_STATE_SOLVED = {
	{ 1, 2, 3, 4 },
	{ 5, 6, 7, 8 },
	{ 9, 10, 11, 12 },
	{ 13, 14, 15, 0 },
}

function Board_init()
	-- Start in a solved state, perform n random moves to shuffle
	-- into a solvable configuration.
	local board = {
		{ 1, 2, 3, 4 },
		{ 5, 6, 7, 8 },
		{ 9, 10, 11, 12 },
		{ 13, 14, 15, 0 },
	}

	Board_shuffle(board, 1000)

	return board
end

function Board_draw(board)
	if Board_is_solved(board) then
		cls(11)
		return
	end
	for i, row in ipairs(board) do
		for j, value in ipairs(row) do
			local sprite = BOARD_VAL_SPRITE_MAP[value]
			local x = (BOARD_C_SIZE * (j - 1))
			local y = (BOARD_C_SIZE * (i - 1))
			spr(sprite, x, y, 2, 2)
		end
	end
end

function Board_available_moves(board)
	local zero_pos = Board_zero_position(board)
	local moves = {}

	if zero_pos.j == 1 then
		add(moves, BOARD_MOVE_RIGHT)
	elseif zero_pos.j == #board[1] then
		add(moves, BOARD_MOVE_LEFT)
	else
		add(moves, BOARD_MOVE_RIGHT)
		add(moves, BOARD_MOVE_LEFT)
	end

	if zero_pos.i == 1 then
		add(moves, BOARD_MOVE_DOWN)
	elseif zero_pos.i == #board then
		add(moves, BOARD_MOVE_UP)
	else
		add(moves, BOARD_MOVE_DOWN)
		add(moves, BOARD_MOVE_UP)
	end

	return moves
end

function Board_shuffle(board, n)
	for _ = 1, n do
		local moves = Board_available_moves(board)
		local move = moves[flr(rnd(#moves)) + 1]
		Board_make_move(board, move)
	end
end

function Board_make_move(board, move)
	-- printh("Making move: " .. move.i .. move.j)
	local zero_pos = Board_zero_position(board)
	local target_i = zero_pos.i + move.i
	local target_j = zero_pos.j + move.j

	-- swap zero with target
	board[zero_pos.i][zero_pos.j], board[target_i][target_j] = board[target_i][target_j], board[zero_pos.i][zero_pos.j]
end

function Board_zero_position(board)
	for i, row in ipairs(board) do
		for j, value in ipairs(row) do
			if value == 0 then
				return { i = i, j = j }
			end
		end
	end
end

function Board_is_solved(board)
	for i, row in ipairs(board) do
		for j, value in ipairs(row) do
			if value ~= BOARD_STATE_SOLVED[i][j] then
				return false
			end
		end
	end
	return true
end

function Board_print(board)
	for _, row in ipairs(board) do
		local row_str = ""
		for _, value in ipairs(row) do
			row_str = row_str .. tostring(value) .. " "
		end
		printh(row_str)
	end
end
