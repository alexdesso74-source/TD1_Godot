class_name Player

extends Area2D

@export var speed: float = 600.0
@export var acceleration: float = 4000.0
@export var max_tilt_degrees: float = 15.0
@export var x_limit: float = 320.0
@export var max_life: int = 3  
@export var explosion_scene: PackedScene
@export var invicibility_timer: Timer 
var is_invincible: bool = false

var velocity: Vector2 = Vector2.ZERO
var life: int
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var sprite: Sprite2D = $Sprite2D
@onready var invincibility_tile:Timer = $InvicibilityTimer

func _ready() -> void:
	life = max_life

# --- 1.2 : déplacement. Le Player a une collision, donc on le bouge dans _physics_process
func _physics_process(delta: float) -> void:
	var target_velocity: Vector2 = read_direction() * speed
	# Juice : accélération et freinage progressifs, le vaisseau a du poids
	velocity = velocity.move_toward(target_velocity, acceleration * delta)
	position += velocity * delta
	position.x = clamp(position.x, -x_limit, x_limit)
	# Juice : le vaisseau s'incline dans le sens du mouvement
	sprite.rotation = deg_to_rad(max_tilt_degrees) * velocity.x / speed

func read_direction() -> Vector2:
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	# Au doigt (ou à la souris) : on rejoint la position X du doigt, en ralentissant à l'approche
	if Input.is_action_pressed("touch"):
		var distance_to_finger: float = get_global_mouse_position().x - global_position.x
		direction.x = clamp(distance_to_finger / 60.0, -1.0, 1.0)
	return direction

# --- 1.4 : dégâts (appelé par les ennemis)
func take_damage(amount: int) -> void:
	if is_invincible:
		return
	is_invincible = true
	invicibility_timer.start()
	var blink_tween:Tween = get_tree().create_tween()
	blink_tween.tween_property(sprite,"modulate:a",0.4,0.25)
	blink_tween.tween_property(sprite,"modulate:a",1.0,0.25)
	blink_tween.set_loops(5)
	blink_tween.play()

	var strech_tween:Tween = get_tree().create_tween()
	sprite.scale = Vector2(1,1)
	strech_tween.tween_property(sprite,"scale",Vector2(1.3,0.7),0.25)
	strech_tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	strech_tween.play()
	
	if life <= 0:
		return
	GameManager.hitstop(0.1)
	sound.play()
	life -= amount
	GameManager.player_life_changed.emit(life)  # 1.5
	if life <= 0:
		var explosion : Node2D = explosion_scene.instantiate()
		explosion.global_position = global_position
		explosion.scale = Vector2.ONE * 2.0
		get_tree().current_scene.add_child(explosion)
		
		GameManager.trigger_game_over()          # 1.5


func _on_invicibility_timer_timeout() -> void:
	is_invincible = false	
