extends Node
class_name PlayerState
# Player State is like an abstract class, 
# Do not edit this unless you intend to implement behaviour for many states

# NOTE : SEE PlayerStateTemplate_COMMENTED for information on how states should be implemented

const debug = {
	"init": false,
	"enter" : true,
	"exit" : true,
	"tick" : false
}
var player
var debug_one_shot = false

func init(_args):
	player = get_parent()


func on_state_enter():
	if debug.enter:
		print("Enter : " + name)

func on_state_exit():
	if debug.exit:
		print("Exit : " + name)

func tick(_args):
	if !debug_one_shot:
		print("Tick : " + name)
		# print(_args)
		debug_one_shot = true