# README
 
## Set Up
----
1. Extract files directly into your project folder.

2. Connect templates to path

      Project -> Project Settings -> Application -> Editor -> Script Template Search Path  
 
    1. Edit the "Script Template Search Path" to point to "AdvancedKinematic2DPlayerController/script_templates/"
    
    OR

    2. Copy contents of script_templates to your own templates folder</

3. Add Globals.gd as Autoload

 
--- 
## Before you begin
---
 
Please read through :
 
   1 - KinematicPlayerController2D.gd
 
   2 - PlayerState.gd
 
   3 - PlayerStateTemplate_COMMENTED.gd
 

---
## Inputs  
---

 
Inputs are set up entirely via code and values are assigned to a dictionary of raw values, this is then parsed into something usable at the start of every frame.
 
Make sure to make appropriate changes to the raw_input_struct which holds the raw input values and the parsed_input_struct which holds the values you will use regularly in code.

<dl>
<dt><strong>raw_input_struct : </strong></dt>
<dd> Updated with every input event. This could be any number of times in a frame. </dd>
 

<dt><strong>parsed_input_struct : </dt></strong>
<dd>Updated at the start of every frame. This means inputs are polled only once in a frame. The intention is that parsed_input_struct is used by states for triggering state changes.</dd>
 </dl>

---
## States
---
**States** are treated similarly to cartridges for old game consoles. Each cartridge (state) contains everything needed to run itself, or it can ask the console (player_controller) to tell it a few things. When the cartridge is over, it tells the console which cartridge to insert next, but the console must actually eject and replace the cartridge.
 
This way the decisions on which state should be next, and under what conditions a state change should occur happen entirely within the current state.

**In practice the system simply assisgns a new script to the current_state node when the old state determines it is done.**


i.e.  A Jump state could check if the player is grounded, if so it can ask to move to a landing state/ walking state/idle state depending on the desired behavior.
 
      #JumpState

      func init(_args):
         name = "JumpState"
         .init(_args)

*On entering the jump state, play jump animation*

      func on_state_enter():
         .on_state_enter()
         anim_player.play("Jump") 

*When the animation is done, move to a fall state, the states are already setup to recieve signals from the attached Animation Player Node.*

      func on_animation_finished(_anim_name: String):
         .on_animation_finished(_anim_name)
         if _anim_name = "Jump":
            request_state_exit(Globals.player_states.fall, null)
