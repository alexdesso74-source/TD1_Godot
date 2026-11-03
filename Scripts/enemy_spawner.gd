class_name Enemy_spawner
extends Node2D
@export var enemy_scene: PackedScene
@export var range_spawn: float = 640

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn() -> void:
	
	var enemy: Node2D = enemy_scene.instantiate()
	var range: float = randf_range(0,range_spawn)
	enemy.global_position = Vector2(range,0)
	get_tree().current_scene.add_child(enemy)
	


func _on_timer_timeout() -> void:
	spawn() # Replace with function body.
