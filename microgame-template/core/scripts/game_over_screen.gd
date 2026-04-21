extends CanvasLayer

signal retry_pressed
signal title_pressed

@onready var final_score_label: Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/FinalScoreLabel
@onready var best_score_label: Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/BestScoreLabel
@onready var retry_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/RetryButton
@onready var title_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/TitleButton

func _ready() -> void:
	retry_button.pressed.connect(_on_retry_pressed)
	title_button.pressed.connect(_on_title_pressed)

func show_result(final_score: int, best_score: int) -> void:
	final_score_label.text = "Score: %d" % final_score
	best_score_label.text = "Best: %d" % best_score
	show()
	retry_button.grab_focus()

func hide_screen() -> void:
	hide()

func _on_retry_pressed() -> void:
	retry_pressed.emit()

func _on_title_pressed() -> void:
	title_pressed.emit()
