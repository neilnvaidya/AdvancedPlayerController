extends KinematicBody2D

class_name KinematicPlayerController2D

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

# var current_state : PlayerState
export var current_state_display = ""
var current_state
var run_machine = true
var input_struct
# ------------------ Balance Variables ------------------

const move_speed: float = 5.0

const jump_speed: float = 5.0
const jump_dir: Vector2 = Vector2.UP

const gravity_strength: float = 5.0
const gravity_dir: Vector2 = Vector2.DOWN


# ------------------ Ready ------------------
func _ready():
	pass


# ------------------ Physcis Process ------------------
func _physics_process(delta):
	#Get the inputs
	$InputManager.parse_raw_input_struct(delta)

	if run_machine:
		tick_state()

	#Update currentStateDisplay
	current_state_display = current_state.name


# ------------------ State Behaviour ------------------
# State design is done using a cartridge type system. States are slotted in and thrown away when their job is done.

# Each state should handle all of its own behaviour such as:
#		playing/stopping animations
#		Calculating trajectories
#		Spawning bullets etc.


func _enter_tree():
	start_state_machine()


func start_state_machine():
	print("Starting State Machine")
	set_state(PlayerDefaultState.new(), null)


func tick_state():
	if current_state == null:
		set_state(PlayerIdleState.new(), null)
	#Tick the current state
	current_state.tick($InputManager.parsed_input_struct)


func set_state(state, _init_args):
	if state == null:
		if current_state != null:
			print("Error! Trying to set current_state = null. Failed setting state")
			return
		else:
			print(
				"Error! Both current_state and desired state are null, Failed to set state, Setting State to : Default"
			)
			set_state(PlayerDefaultState.new(), null)
	else:
		if current_state != null:
			current_state.on_state_exit()
			current_state.queue_free()

		current_state = state
		add_child(current_state)
		current_state.init(_init_args)
		current_state.on_state_enter()
