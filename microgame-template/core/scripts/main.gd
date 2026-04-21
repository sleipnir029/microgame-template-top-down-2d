extends Node

enum AppState {
	TITLE,
	PLAYING,
	PAUSED,
	GAME_OVER
}

@onready var game = $Game
@onready var hud = $HUD
@onready var title_screen = $TitleScreen
@onready var game_over_screen = $GameOverScreen

var save_service := SaveService.new()
var best_score: int = 0
var current_state: AppState = AppState.TITLE

func _ready() -> void:
	best_score = save_service.load_best_score()
	hud.set_best(best_score)
	hud.hide()
	game.hide()
	game_over_screen.hide_screen()
	title_screen.show_screen()

	title_screen.start_pressed.connect(_on_start_pressed)
	game.score_changed.connect(_on_score_changed)
	game.run_ended.connect(_on_run_ended)
	game_over_screen.retry_pressed.connect(_on_retry_pressed)
	game_over_screen.title_pressed.connect(_on_title_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		if current_state == AppState.PLAYING:
			pause_run()
		elif current_state == AppState.PAUSED:
			resume_run()

	if event.is_action_pressed("restart_run") and current_state == AppState.GAME_OVER:
		start_run()

func _on_start_pressed() -> void:
	start_run()

func _on_retry_pressed() -> void:
	start_run()

func _on_title_pressed() -> void:
	resume_tree_if_needed()
	current_state = AppState.TITLE
	game.stop_run()
	game.hide()
	hud.hide()
	game_over_screen.hide_screen()
	title_screen.show_screen()
	hud.set_score(0)
	hud.set_best(best_score)

func start_run() -> void:
	resume_tree_if_needed()
	current_state = AppState.PLAYING
	title_screen.hide_screen()
	game_over_screen.hide_screen()
	hud.show()
	game.show()
	hud.set_best(best_score)
	hud.set_score(0)
	hud.set_paused(false)
	game.start_run()

func pause_run() -> void:
	current_state = AppState.PAUSED
	get_tree().paused = true
	hud.set_paused(true)

func resume_run() -> void:
	get_tree().paused = false
	current_state = AppState.PLAYING
	hud.set_paused(false)

func resume_tree_if_needed() -> void:
	if get_tree().paused:
		get_tree().paused = false

func _on_score_changed(value: int) -> void:
	hud.set_score(value)

func _on_run_ended(final_score: int) -> void:
	resume_tree_if_needed()
	current_state = AppState.GAME_OVER

	if final_score > best_score:
		best_score = final_score
		save_service.save_best_score(best_score)

	hud.set_best(best_score)
	hud.set_paused(false)
	game.hide()
	game_over_screen.show_result(final_score, best_score)
