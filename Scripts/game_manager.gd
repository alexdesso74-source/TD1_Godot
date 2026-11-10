# Autoload (Project Settings > Globals > Autoload), nommé GameManager.
# Pas de class_name ici : Godot refuse une classe qui porte le nom d'un autoload.
extends Node

signal score_changed(score: int)
signal player_life_changed(life: int)
signal game_over

var score: int = 0
var hit_stop_timer:SceneTreeTimer = null
var is_game_over : bool = false

# --- 1.5
func add_score(points: int) -> void:
	score += points
	score_changed.emit(score)

func trigger_game_over() -> void:
	Engine.time_scale = 0.3
	is_game_over = true
	get_tree().create_timer(1,true,false,true).timeout.connect(on_gameover_timer_end)
	

func restart() -> void:
	score = 0
	get_tree().paused = false
	get_tree().reload_current_scene()

func hitstop(duree: float) -> void:
	if !is_game_over:
		return
	Engine.time_scale = 0.05
	if hit_stop_timer:
		hit_stop_timer.cancel_free()
	hit_stop_timer = get_tree().create_timer(duree, true, false, true)
	hit_stop_timer.timeout.connect(on_hitstop_end)
	
func on_hitstop_end() -> void:
	if !is_game_over:
		return
	Engine.time_scale = 1.0
	hit_stop_timer = null
	
func on_gameover_timer_end() -> void:
	Engine.time_scale = 1.0
	get_tree().paused = true
	game_over.emit()
	
