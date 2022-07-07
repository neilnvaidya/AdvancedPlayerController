extends PlayerState


func init(_args):
	name = "ExampleState"
	.init(_args)
	print(_args)


func on_state_enter():
	.on_state_enter()

func on_state_exit():
	.on_state_exit()


func tick(_args):
	.tick(_args)
	
