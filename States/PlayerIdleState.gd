extends PlayerState
class_name PlayerIdleState


func init(_args):
	name = "IdleState"
	.init(_args)


func on_state_enter():
	.on_state_enter()


func on_state_exit():
	.on_state_exit()


func tick(_args):
	.tick(_args)
