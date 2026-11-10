class_name CameraShake
extends Camera2D


@export var decay : float = 1
@export var max_offset : float = 30

var trauma : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.player_life_changed.connect(on_player_life_changer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var shake_value:float = trauma * trauma
	var rand_offset_dir:Vector2 = Vector2(
		randf_range(-1,1),randf_range(-1,1)
		)
	offset = rand_offset_dir* shake_value * max_offset
	trauma = max(trauma - (decay * delta), 0.0)
	
func add_trauma(value:float) -> void:
	trauma += value
	trauma = clamp(trauma,0.0,1.0)

func on_player_life_changer(new_life:int) -> void:
	add_trauma(0.6)
	if(new_life == 0 ):
		add_trauma(1)
		
	
