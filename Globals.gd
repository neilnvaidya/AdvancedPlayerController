extends Node

# ------------------ Balance Variables ------------------

const move_speed: float = 5.0

const jump_speed: float = 5.0
const jump_dir: Vector2 = Vector2.UP

const gravity_strength: float = 5.0
const gravity_dir: Vector2 = Vector2.DOWN
const test_fall_size: float = 2.0

var player_states = {
	"default": "res://PlayerController/States/PlayerDefaultState.gd",
	"example":"res://PlayerController/States/PlayerExampleState.gd"
}
