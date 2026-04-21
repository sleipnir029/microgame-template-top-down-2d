extends CanvasLayer

signal start_pressed

@onready var start_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/StartButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed() -> void:
	start_pressed.emit()

func show_screen() -> void:
	show()
	start_button.grab_focus()

func hide_screen() -> void:
	hide()
