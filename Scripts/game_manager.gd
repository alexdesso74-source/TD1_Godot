extends Node

var global_score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

signal game_over()
signal score_changed(score: int)
signal player_life_changed(life:int)
	
	
func add_score(points: int) -> void:
	global_score += points
	score_changed.emit(global_score)
	

func trigger_game_over() -> void:
	get_tree().paused = true
	game_over.emit()

func restart() -> void:
	global_score = 0
	get_tree().paused = false
	get_tree().reload_current_scene.call_deferred()
