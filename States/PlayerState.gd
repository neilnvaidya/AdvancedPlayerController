extends Node
class_name PlayerState
# Player State is like an abstract class,
# Do not edit this unless you intend to implement behaviour for many states

# NOTE : SEE PlayerStateTemplate_COMMENTED for information on how states should be implemented


const debug = {"init": false, "enter": true, "exit": true, "tick": false}
var debug_one_shot = false
var anim_player
var init_args

signal state_exit_request_signal(_self, _new_state, _args)
signal move_player_request_signal(vel)


func init(_args):
	anim_player = get_parent().animation_player
	init_args = _args


func on_state_enter():
	if debug.enter:
		print("Enter : " + name)


func on_state_exit():
	if debug.exit:
		print("Exit : " + name)


func tick(_args):
	if !debug_one_shot:
		print("Tick : " + name)
		debug_one_shot = true


func on_animation_started(_anim_name: String):
	pass


func on_animation_finished(_anim_name: String):
	pass


func on_animation_changed(_anim_name: String):
	pass


func request_state_exit(_new_state, _args):
	emit_signal("state_exit_request_signal", self, _new_state, _args)

func move_player(vel):
	emit_signal("move_player_request_signal",vel)