extends RefCounted
class_name SaveService

const SAVE_PATH := "user://save_data.json"

func load_best_score() -> int:
	if not FileAccess.file_exists(SAVE_PATH):
		return 0

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return 0

	var text := file.get_as_text()
	var parsed = JSON.parse_string(text)
	if typeof(parsed) == TYPE_DICTIONARY and parsed.has("best_score"):
		return int(parsed["best_score"])

	return 0

func save_best_score(value: int) -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return

	var data := {
		"best_score": value
	}
	file.store_string(JSON.stringify(data))
