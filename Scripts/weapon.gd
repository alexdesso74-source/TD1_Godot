class_name Weapon
extends Node2D

@export var bullet_scene: PackedScene
@export var time_between_shots: float 
@export var max_dispersion: float = 0.1
var timer: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = time_between_shots


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	if timer <=0:
		shoot()
		
func shoot() -> void:
	
	var bullet: Node2D = bullet_scene.instantiate()
	$Sound.pitch_scale = randf()
	$Sound.play()
	var dispersition: float = randf_range(-max_dispersion,max_dispersion)
	bullet.global_position = global_position
	bullet.rotation = bullet.rotation + dispersition
	get_tree().current_scene.add_child(bullet)
	timer = time_between_shots
