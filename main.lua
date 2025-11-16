---@diagnostic disable: lowercase-global

BTN_LEFT = 0
BTN_RIGHT = 1
BTN_UP = 2
BTN_DOWN = 3
BTN_O = 4
BTN_X = 5

State = {}

function _init()
	poke(0x5f2c, 3) -- 64x64 map size
	State.board = Board_init()
	State.marker = Marker_init()
end

function _update()
	Marker_update(State.marker)
end

function _draw()
	cls()
	map()
	if Board_is_solved(State.board) then
		cls()
		print("Congratulations!", 2, 20, 7)
		print("You won!", 2, 30, 7)
		return
	end
	Board_draw(State.board)
	Marker_draw(State.marker)
end
