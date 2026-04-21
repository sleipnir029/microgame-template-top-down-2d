extends Area2D

signal hit_hazard
signal collected_pickup(pickup: Area2D)

@export var move_speed: float = 320.0
@export var arena_min: Vector2 = Vector2(100, 100)
@export var arena_max: Vector2 = Vector2(1180, 620)

func _process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += input_vector * move_speed * delta
	position.x = clamp(position.x, arena_min.x, arena_max.x)
	position.y = clamp(position.y, arena_min.y, arena_max.y)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("hazard"):
		hit_hazard.emit()
	elif area.is_in_group("pickup"):
		collected_pickup.emit(area)
