class_name Bullet
extends Area2D
@export var speed: float = 600.0
@export var hit_fx: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	position += Vector2.UP.rotated(rotation) * speed  * delta

		
	
	if (position.y < 0):
		queue_free()
		


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		area.take_damage(1)
		var hit:Node2D = hit_fx.instantiate()
		hit.global_position = global_position
		get_tree().current_scene.add_child(hit)
		queue_free()
	
