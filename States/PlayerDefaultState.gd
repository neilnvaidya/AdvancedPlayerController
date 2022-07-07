extends PlayerState
class_name PlayerDefaultState

#This is a passthrough type state, used only when starting up.


func init(_args):
	name = "DefaultState"
	.init(_args)


func on_state_enter():
	.on_state_enter()
	player.set_state(PlayerIdleState.new(), null)


func on_state_exit():
	.on_state_exit()


func tick(_args):
	.tick(_args)
