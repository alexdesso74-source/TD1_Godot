extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var lives: HBoxContainer = $Lives
@onready var damage_flash: ColorRect = $DamageFlash
@onready var game_over_panel: Control = $GameOverPanel

func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.player_life_changed.connect(_on_player_life_changed)
	GameManager.game_over.connect(_on_game_over)
	score_label.text = "%06d" % GameManager.score
	score_label.pivot_offset = score_label.size / 2

# --- 1.5
func _on_score_changed(score: int) -> void:
	score_label.text = "%06d" % score
	# Juice : le score "punch" à chaque gain
	score_label.scale = Vector2(1.4, 1.4)
	create_tween().tween_property(score_label, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_player_life_changed(life: int) -> void:
	for i: int in lives.get_child_count():
		lives.get_child(i).visible = i < life
	# Juice : flash rouge plein écran
	damage_flash.color.a = 0.4
	create_tween().tween_property(damage_flash, "color:a", 0.0, 0.3)

func _on_game_over() -> void:
	
	game_over_panel.visible = true
	game_over_panel.scale = Vector2.ZERO
	game_over_panel.modulate.a = 0.0
	var game_over_tween:Tween = get_tree().create_tween()
	game_over_tween.set_parallel(true)
	game_over_tween.tween_property(game_over_panel,"scale",Vector2.ONE,0.6)
	game_over_tween.tween_property(game_over_panel,"modulate:a",1.0,0.6)
	game_over_tween.set_trans(Tween.TRANS_BACK)
	game_over_tween.set_ignore_time_scale(true)
	game_over_tween.set_pause_mode(Tween.TWEEN_PAUSE_STOP)
	game_over_tween.play()
	

func _on_restart_button_pressed() -> void:
	GameManager.restart()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
