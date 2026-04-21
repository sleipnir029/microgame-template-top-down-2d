extends CanvasLayer

@onready var score_label: Label = $MarginContainer/HBoxContainer/ScoreLabel
@onready var best_label: Label = $MarginContainer/HBoxContainer/BestLabel

func set_score(value: int) -> void:
	score_label.text = "Score: %d" % value

func set_best(value: int) -> void:
	best_label.text = "Best: %d" % value
