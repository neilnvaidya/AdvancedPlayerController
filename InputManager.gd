extends Node

#This input manager works by separating all inputs into two types, Movement and Actions

#Movement is almost always a Vector2 (unless you are making a flying/driving game in which case this may be the wrong system for you)
# This means either WASD on the keyboard, or the Joypad LEFT STICK

#Actions are anything else. i.e. Jump, Roll, Attack, Block etc..
#These are done by pressing buttons or triggers
# you must implement the relevant code in the following places, there is an example* placed in every location
# 1) Input Map
# 2) Raw Input Struct
# 3) Parsed Input Struct
# 4) _input(event) function x2 - for joypad and for keyboard
# 5) parse_raw_input_struct() function x2 - for joypad and for keyboard

#This input_action is an example, use this to copy and pased into the relevant section
# var input_action_b = {"pressed": false, "pressed_this_frame": false, "released_this_frame": false, "timer": 0.0}

#TODO - compelte implementations for triggers
#TODO - compelte implementations for rest of joypad buttons
#TODO - compelte implementations for Arrowkeys/Right Stick


# ------------------ Input Maps ------------------

#KEYBOARD
var keyboard_input_map = {
	#Movement
	"up": KEY_W,
	"down": KEY_S,
	"left": KEY_A,
	"right": KEY_D,
	#Actions
	"jump": KEY_SPACE,
	"roll": KEY_E,
	#example*
	"example": KEY_CONTROL
}

#JOYPAD
var joypad_input_map = {
	#Movement
	"left_stick_horizontal": JOY_AXIS_0,
	"left_stick_vertical": JOY_AXIS_1,
	#Actions
	"jump": JOY_BUTTON_0,
	"roll": JOY_BUTTON_1,
	#example*
	"example": JOY_BUTTON_21
}

# Set this to"joypad_input_map" if joypad is desired.
var selected_input_map = keyboard_input_map

# ------------------ Input Variables ------------------
# Input structs are dictionaries that show the values for inputs.

# RAW STRUCTS -  set by _input(event) function ONLY
# KEYBOARD
var k_raw_input_struct = {
	#Movement
	"up": false,
	"down": false,
	"left": false,
	"right": false,
	#Actions
	"jump_pressed": false,
	"roll_pressed": false,
	#example*
	"example_pressed": false
}
# JOYPAD
var j_raw_input_struct = {
	#Movement
	"left_stick_x": 0.0,
	"left_stick_y": 0.0,
	#Actions
	"jump_pressed": false,
	"roll_pressed": false,
	#example*
	"example_pressed": false
}

# Formatted Structs - set by _set_formatted_struct - called during physics_process
var parsed_input_struct = {
	#Movement
	"move_input": Vector2.ZERO,
	#Actions
	"jump_action":
	{"pressed": false, "pressed_this_frame": false, "released_this_frame": false, "timer": 0.0},
	"roll_action":
	{"pressed": false, "pressed_this_frame": false, "released_this_frame": false, "timer": 0.0},
	#example*
	"example_action":
	{"pressed": false, "pressed_this_frame": false, "released_this_frame": false, "timer": 0.0}
}


# ------------------ Input ------------------
# NOTE: If built-in imput map is used (Poject -> Project Settings -> Input Map)
# 		Replace the contents of _input function with the given example
func _input(event):
#	Example for use of built-in imput map
#	if event.is_action_pressed("built_in_map_example_action"):
#		built_in_input_map_example_val = event.is_pressed()

	#KEYBOARD INPUTS
	if event is InputEventKey:
		#Movement
		if event.scancode == keyboard_input_map.up:
			k_raw_input_struct.up = event.is_pressed()

		if event.scancode == keyboard_input_map.down:
			k_raw_input_struct.down = event.is_pressed()

		if event.scancode == keyboard_input_map.left:
			k_raw_input_struct.left = event.is_pressed()

		if event.scancode == keyboard_input_map.right:
			k_raw_input_struct.right = event.is_pressed()

		#Actions
		if event.scancode == keyboard_input_map.jump:
			k_raw_input_struct.jump_pressed = event.is_pressed()

		if event.scancode == keyboard_input_map.roll:
			k_raw_input_struct.roll_pressed = event.is_pressed()

		#example*
		if event.scancode == keyboard_input_map.example:
			k_raw_input_struct.example = event.is_pressed()

	#GAMEPAD INPUTS
	if event is InputEventJoypadMotion:
		#Movement
		if event.axis == joypad_input_map.left_stick_horizontal:
			j_raw_input_struct.left_stick_x = event.axis_value
		if event.axis == joypad_input_map.left_stick_vertical:
			j_raw_input_struct.left_stick_y = event.axis_value

	if event is InputEventJoypadButton:
		#Actions (buttons)
		if event.button_index == joypad_input_map.jump:
			j_raw_input_struct.jump = event.pressed
		#example*
		if event.button_index == joypad_input_map.example:
			j_raw_input_struct.example_button = event.pressed


# Parse raw inputs into useable values, ie combine move inputs into a vector, handle input actions
# Implement custom code here.
func parse_raw_input_struct(delta):
	#Keyboard
	if selected_input_map == keyboard_input_map:
		parse_key_inputs(delta)

	#Joypad
	if selected_input_map == joypad_input_map:
		parse_joypad_inputs(delta)


func parse_joypad_inputs(delta):
	# -------------------- Movement --------------------
	parsed_input_struct.move_input = Vector2(
		j_raw_input_struct.left_stick_x, j_raw_input_struct.left_stick_y
	)
	# -------------------- Actions --------------------
	parse_input_action_button(
		j_raw_input_struct.jump_pressed, parsed_input_struct.jump_action, delta
	)
	parse_input_action_button(
		j_raw_input_struct.roll_pressed, parsed_input_struct.roll_action, delta
	)
	#example*
	parse_input_action_button(
		j_raw_input_struct.example_pressed, parsed_input_struct.exampled_aciton, delta
	)


func parse_key_inputs(delta):
	parsed_input_struct.move_input_vec = Vector2.ZERO
	# -------------------- Movement --------------------
	parse_keyboard_movement_input()

	# -------------------- Actions --------------------

	parse_input_action_button(
		k_raw_input_struct.jump_pressed, parsed_input_struct.jump_action, delta
	)
	parse_input_action_button(
		k_raw_input_struct.roll_pressed, parsed_input_struct.roll_action, delta
	)
	# #example*
	parse_input_action_button(
		k_raw_input_struct.example_pressed, parsed_input_struct.example_action, delta
	)


func parse_keyboard_movement_input():
	#set move_vec
	if k_raw_input_struct.up:
		parsed_input_struct.move_input.y += 1
	if k_raw_input_struct.down:
		parsed_input_struct.move_input.y -= 1
	if k_raw_input_struct.left:
		parsed_input_struct.move_input.x -= 1
	if k_raw_input_struct.right:
		parsed_input_struct.move_input.x += 1


func parse_input_action_button(raw_value, action, delta):
	#Set pressed this frame
	if raw_value:
		if !action.pressed:
			action.pressed_this_frame = true
			# print("p1")
		elif action.pressed_this_frame:
			action.pressed_this_frame = false
	#set released this frame
	else:
		if action.pressed:
			action.released_this_frame = true
		elif action.released_this_frame:
			action.released_this_frame = false
	#Set pressed
	action.pressed = raw_value
	#Set timer
	if action.pressed:
		action.timer += delta
	else:
		action.timer = 0.0
