extends CanvasLayer

@onready var score_label: Label = $MarginContainer/HBoxContainer/ScoreLabel
@onready var best_label: Label = $MarginContainer/HBoxContainer/BestLabel
@onready var pause_label: Label = $PauseLabel

func _ready() -> void:
	set_paused(false)

func set_score(value: int) -> void:
	score_label.text = "Score: %d" % value

func set_best(value: int) -> void:
	best_label.text = "Best: %d" % value

func set_paused(value: bool) -> void:
	pause_label.visible = value
