extends PlayerState

#Constructor (of sorts)
# Technically not a constructor, but is called during set_state() method just after state is instanced
# args can take any form, usually some dictionary is passed containing pertinant data, just be consistent.
func init(_args):
	# change name property to reflect class_name -  ie for class_name = PlayerIdleState, name = IdleState
	name = "TemplateState_COMMENTED"
	.init(_args)

# Keep on_state_enter and _on_state_exit efficient. Use to set flags and start/stop processes.
# Consider coroutines for computationally heavy behaviour
# Both are called during the same frame as well as a whole tick
func on_state_enter():
	.on_state_enter()


# _on_state_exit is called AFTER the next state is initialised and added to the tree.
func on_state_exit():
	.on_state_exit()


# Called during every physics_process step. Used for main loop in state. In this case input_struct is being passed as argument
func tick(_args):
	.tick(_args)


#NOTE
#Remember to register the state in Globals.player_states