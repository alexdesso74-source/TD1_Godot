class_name Bullet
extends Area2D
@export var speed: float = 600.0

var velocity: Vector2 = Vector2(0,-1).rotated(rotation)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	position += velocity * speed  * delta
	
	if (position.y < 0):
		queue_free()
		
