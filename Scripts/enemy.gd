class_name Enemy
extends Area2D
@onready var sprite: Sprite2D = $sprite
@export var speed: float = 300.0
@export var health: int = 2
@export var enemie_score: int = 10
@export var explosion_fx: PackedScene
@onready var flash_timer: Timer = $OneShot

@export var knockback_force: float = 400
@export var knockback_recovery: float = 2000

var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2.DOWN * speed
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var target_velocity:Vector2 = Vector2.DOWN * speed
	velocity = velocity.move_toward(target_velocity,knockback_recovery*delta)
	global_position += velocity*delta
	
	if (position.y > 1280):
		queue_free()
		
func take_damage(amount: int) ->void:
	health -= amount
	sprite.modulate = Color(10,10,10)
	flash_timer.start()
	velocity = Vector2.UP * knockback_force
		

	if health <= 0:
		$AudioStreamPlayer2D.play()
		var explosion:Node2D = explosion_fx.instantiate()
		explosion.global_position = global_position
		get_tree().current_scene.add_child(explosion)
		GameManager.add_score(enemie_score)
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		area.take_damage(1)
		queue_free()


func _on_one_shot_timeout() -> void:
	sprite.modulate = Color.WHITE
