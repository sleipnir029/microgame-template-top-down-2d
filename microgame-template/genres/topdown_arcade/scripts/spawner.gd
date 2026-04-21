extends Node

signal spawn_requested(position: Vector2, velocity: Vector2)

@export var arena_min: Vector2 = Vector2(80, 80)
@export var arena_max: Vector2 = Vector2(1200, 640)
@export var spawn_interval: float = 1.2
@export var hazard_speed: float = 180.0

@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.wait_time = spawn_interval

func start() -> void:
	spawn_timer.start()

func stop() -> void:
	spawn_timer.stop()

func reset() -> void:
	spawn_interval = 1.2
	hazard_speed = 180.0
	spawn_timer.wait_time = spawn_interval

func ramp_difficulty() -> void:
	spawn_interval = max(0.45, spawn_interval - 0.08)
	hazard_speed += 12.0
	spawn_timer.wait_time = spawn_interval

func _on_spawn_timer_timeout() -> void:
	var side := randi() % 4
	var spawn_pos := Vector2.ZERO

	match side:
		0:
			spawn_pos = Vector2(randf_range(arena_min.x, arena_max.x), arena_min.y)
		1:
			spawn_pos = Vector2(arena_max.x, randf_range(arena_min.y, arena_max.y))
		2:
			spawn_pos = Vector2(randf_range(arena_min.x, arena_max.x), arena_max.y)
		3:
			spawn_pos = Vector2(arena_min.x, randf_range(arena_min.y, arena_max.y))

	var center := Vector2((arena_min.x + arena_max.x) * 0.5, (arena_min.y + arena_max.y) * 0.5)
	var direction := (center - spawn_pos).normalized()
	spawn_requested.emit(spawn_pos, direction * hazard_speed)
