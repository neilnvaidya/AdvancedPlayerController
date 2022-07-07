extends PlayerState

#This is a passthrough type state, used only when starting up.


func init(_args):
	name = "DefaultState"
	.init(_args)


func on_state_enter():
	.on_state_enter()


func on_state_exit():
	.on_state_exit()


func tick(_args):
	.tick(_args)
	request_state_exit(Globals.player_states.example,"This is how you change states!")
