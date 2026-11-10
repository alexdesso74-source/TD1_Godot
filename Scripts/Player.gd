class_name Player
extends Area2D

@onready var sprite: Sprite2D = $Sprite2D


@export var speed: float = 600.0
@export var x_limit: float = 340.0
@export var y_limit: float = 620.0
@export var acceleration: float = 3000
@export var max_rotation: float = 15.0
@export var health: int = 3

var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass # une fois, quand le nœud apparaît
	
func _process(delta: float) -> void:
	pass

	
func _physics_process(delta: float) -> void:
	var target_velocity: Vector2 = read_direction() * speed

	velocity = velocity.move_toward(target_velocity, acceleration * delta)
	position += velocity  * delta
	position.x = clamp(position.x,40,x_limit*2)
	position.y = clamp(position.y,40,y_limit*2)
	sprite.rotation = deg_to_rad(max_rotation) * (velocity.x / speed)
	
func read_direction() -> Vector2:
	var direction : Vector2 = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y= Input.get_axis("move_up", "move_down")

	if Input.is_action_pressed("touch"):
		var xDestination: float = get_global_mouse_position().x
		var yDestination: float = get_global_mouse_position().y
		var xDistance_to_finger : float = xDestination - position.x
		var yDistance_to_finger : float = yDestination - position.y
		direction.x = clamp(xDistance_to_finger/60, -1,1)
		direction.y = clamp(yDistance_to_finger/60, -1,1)

	
	return direction

	
func take_damage(amount: int) ->void:
	health -= amount
	GameManager.player_life_changed.emit(health)
	if health <= 0:
		
		GameManager.trigger_game_over()
	
	
		
