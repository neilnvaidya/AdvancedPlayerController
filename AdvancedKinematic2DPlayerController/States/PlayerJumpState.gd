extends PlayerState
class_name PlayerJumpState


func init(_args):
	name = "JumpState"
	.init(_args)

func on_state_enter():
	.on_state_enter()


func on_state_exit():
	._on_state_exit()

func tick(_args):
	.tick(_args)
