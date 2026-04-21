extends Area2D

@export var velocity: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	position += velocity * delta

	if position.x < -100 or position.x > 1380 or position.y < -100 or position.y > 820:
		queue_free()
