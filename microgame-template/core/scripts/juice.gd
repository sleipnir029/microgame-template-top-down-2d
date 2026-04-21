extends Node
class_name Juice

static func flash_canvas_item(item: CanvasItem, color: Color, duration: float = 0.08) -> void:
	if item == null:
		return

	var original_modulate := item.modulate
	item.modulate = color

	var tween := item.create_tween()
	tween.tween_property(item, "modulate", original_modulate, duration)

static func pulse_scale(node: Node2D, amount: float = 1.15, duration: float = 0.08) -> void:
	if node == null:
		return

	var original_scale := node.scale
	var tween := node.create_tween()
	tween.tween_property(node, "scale", original_scale * amount, duration)
	tween.tween_property(node, "scale", original_scale, duration)
