# README
 
## Set Up
### 1 - Extract files directly into your project folder.
### 2 - Connect templates to path
#### Project -> Project Settings -> Application -> Editor -> Script Template Search Path
   A - Edit the "Script Template Search Path" to point to "AdvancedKinematic2DPlayerController/script_templates/"
  
   --- OR ---
 
   B - Copy contents of script_templates to your own templates folder
 
## Before you begin
 
Please read through :
 
   1 - KinematicPlayerController2D.gd
 
   2 - PlayerState.gd
 
   3 - PlayerStateTemplate_COMMENTED.gd
 
## How it works
 
### Inputs
 
Inputs are set up entirely via code and values are assigned to a dictionary of raw values, this is then parsed into something usable. 
 
This means that to change the bindings or add a new input, you simply have to change the values in relevant input map (a dictionary of scancode constants). Alternatively you can create a new input map(s) and have it assigned as the current_input_map at will.
 
Make sure to make appropriate changes to the raw_input_struct which holds the raw input values and the parsed_input_struct which holds the values you will use regularly in code.
 
raw_input_struct values are updated with every input event. This could be any number of times in a frame.
 
parsed_input_struct values are updated at the start of every frame. This means inputs are polled only once in a frame. The intention is that parsed_input_struct is used by states for triggering state changes.
 
   if jump input (in the parsed struct) -> move to jump state
 
  
### States and StateMachine
States are treated similarly to cartridges for old game consoles. Each cartridge (state) contains everything needed to run itself, or it can ask the console (playercoller) to tell it a few things. When the cartridge is over, it shuts itself down and tells the console which cartridge to insert next.
 
This way the decisions on which state should be next, and under what conditions a state change should occur happen entirely within the current state.

i.e.  A Jump state could check if the player is grounded, if so it can ask to move to a landing state/ walking state/idle state depending on the desired behavior.
 
   class_name JumpState
 
   #the main process loop
   func tick():
 
       # If the player is grounded
       if is_grounded():
 
           # Move to the walking state while passing relevant arguments
           player.set_state(WalkState.new(args))
 
   func is_grounded():
       # Perform some grounded check here
       return result
 
 
 

Demo uses resources from -

Warrior-Free Animation set V1.3 by Clembod
https://clembod.itch.io/warrior-free-animation-set
