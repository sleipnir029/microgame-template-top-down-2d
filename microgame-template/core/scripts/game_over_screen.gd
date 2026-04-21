extends CanvasLayer

signal retry_pressed
signal title_pressed

@onready var final_score_label: Label = $Panel/FinalScoreLabel
@onready var best_score_label: Label = $Panel/BestScoreLabel
@onready var retry_button: Button = $Panel/RetryButton
@onready var title_button: Button = $Panel/TitleButton

func _ready() -> void:
	retry_button.pressed.connect(_on_retry_pressed)
	title_button.pressed.connect(_on_title_pressed)

func show_result(final_score: int, best_score: int) -> void:
	final_score_label.text = "Score: %d" % final_score
	best_score_label.text = "Best: %d" % best_score
	show()

func hide_screen() -> void:
	hide()

func _on_retry_pressed() -> void:
	retry_pressed.emit()

func _on_title_pressed() -> void:
	title_pressed.emit()
