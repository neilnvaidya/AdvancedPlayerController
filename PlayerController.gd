extends KinematicBody2D

class_name PlayerController

# This script controls a KinematicBody2D.
#
# This is an advanced implementation of a character controller,
# It is especially useful for complex behavior patterns
#
# Be sure that you will have a large number of states or very complex states
# before using this implementation
#
# The advantage of this style of playercontroller is that it is highly modular.
# The state pattern can be replicated to control any physics body easily

# ------------------ IMPORTANT NOTE ------------------
# Set all the constants below to fit specific needs.
# Default values are given

# Remember to see PlayerTemplateState_COMMENTED.gd (or load u

var current_state: PlayerState
export var current_state_display = ""
var run_machine = true

#Trackers to help states know when to exit
var _is_grounded
var velocity
var _in_hit_stun
var last_position
var input_struct

#Tick args dict is passed to states every frame, containes the above trackers
var state_tick_args = {
	"grounded": false,
	"velocity": Vector2.ZERO,
	"in_hit_stun": false,
	"last_position": Vector2.ZERO,
	"current_position": Vector2.ZERO,
	"input_struct": {}
} setget set_state_tick_args

#ref to animation player
var animation_player


# ------------------ Ready ------------------
func _ready():
	pass
	# print(animation_player)


# ------------------ Physcis Process ------------------
func _physics_process(delta):
	#Get the inputs
	$InputManager.parse_raw_input_struct(delta)
	input_struct = $InputManager.parsed_input_struct

	update_state_tick_args()

	if run_machine:
		current_state.tick(state_tick_args)

	#Update currentStateDisplay
	current_state_display = current_state.name


# ------------------ State Behaviour ------------------
# State design is done using a cartridge type system. States are slotted in and thrown away when their job is done.

# Each state should handle all of its own behaviour such as:
#		playing/stopping animations
#		Calculating trajectories
#		Spawning bullets etc.

#If the State needs the player to do something, it should send a signal to the player. ie to exit, or to move

#When a state has done its job it sends a "state_exit_request_signal" this is handled by the PlayerController.
#The state should never directly call any methods or properties of the PlayerController, instead pass them to the state inside some argument.


#called when node enters treee
func _enter_tree():
	animation_player = get_node("AnimationPlayer")
	start_state_machine()


#start the statemachine with a default state
func start_state_machine():
	print("Starting State Machine")
	update_state_tick_args()
	set_state(Globals.player_states.default, {"grounded": state_tick_args.grounded})


#tick the current state
func tick_state():
	if current_state == null:
		set_state(Globals.player_states.default, {"grounded": state_tick_args.grounded})
	current_state.tick(state_tick_args)


#update the tick_args, these are passed to current state every frame
func update_state_tick_args():
	# var _collision = move_and_collide(Vector2.DOWN * Globals.test_fall_size, false, true, true)

	state_tick_args.grounded = $RayCast2D.is_colliding()
	state_tick_args.last_position = state_tick_args.current_position
	state_tick_args.current_position = position
	state_tick_args.velocity = state_tick_args.current_position - state_tick_args.last_position
	state_tick_args.in_hit_stun = _in_hit_stun
	state_tick_args.input_struct = input_struct


#setter
func set_state_tick_args(val):
	state_tick_args = val


#set current state, call on_state_exit, on_state_enter, free old state, and connect relevant signals
func set_state(state_ref, _init_args):
	#Handle null exceptions
	if state_ref == null:
		if current_state != null:
			print("Error! Trying to set current_state = null. Failed setting state")
			return
		else:
			print(
				"Error! Both current_state and desired state are null, Failed to set state, Setting State to : Default"
			)
			set_state(Globals.player_states.default, {"grounded": state_tick_args.grounded})
	else:
		#Exit current state
		if current_state != null:
			current_state.on_state_exit()
			current_state.queue_free()

		#assign new state, add to tree, init
		var n = PlayerState.new()
		n.set_script(load(state_ref))
		current_state = n
		add_child(current_state)
		current_state.init(_init_args)

		#Connect signals
# warning-ignore:return_value_discarded
		$AnimationPlayer.connect("animation_started", current_state, "on_animation_started")
# warning-ignore:return_value_discarded
		$AnimationPlayer.connect("animation_finished", current_state, "on_animation_finished")
# warning-ignore:return_value_discarded
		$AnimationPlayer.connect("animation_changed", current_state, "on_animation_changed")
# warning-ignore:return_value_discarded
		current_state.connect("state_exit_request_signal", self, "on_state_request_exit")
# warning-ignore:return_value_discarded
		current_state.connect("move_player_request_signal", self, "on_state_request_player_move")

		#Enter new state
		current_state.on_state_enter()


#recieve state exit request signal
func on_state_request_exit(_state, _new_state, _args):
	var a = {"grounded": state_tick_args.grounded, "exit_args": _args}
	set_state(_new_state, a)


func on_state_request_player_move(vel):
	move_and_collide(vel)
