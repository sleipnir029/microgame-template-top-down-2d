extends Node2D

signal score_changed(value: int)
signal run_ended(final_score: int)

const PLAYER_SCENE := preload("res://genres/topdown_arcade/scenes/Player.tscn")
const HAZARD_SCENE := preload("res://genres/topdown_arcade/scenes/Hazard.tscn")
const PICKUP_SCENE := preload("res://genres/topdown_arcade/scenes/Pickup.tscn")

@onready var camera: Camera2D = $Camera2D
@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var entities: Node2D = $Entities
@onready var spawner = $Spawner
@onready var score_timer: Timer = $ScoreTimer
@onready var difficulty_timer: Timer = $DifficultyTimer
@onready var pickup_timer: Timer = $PickupTimer

var player: Area2D
var score: int = 0
var running: bool = false
var shake_strength: float = 0.0
var camera_base_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	visible = false
	camera.enabled = true
	camera.position = player_spawn.position
	camera.offset = Vector2.ZERO
	camera_base_offset = camera.offset

	spawner.spawn_requested.connect(_on_spawn_requested)
	score_timer.timeout.connect(_on_score_timer_timeout)
	difficulty_timer.timeout.connect(_on_difficulty_timer_timeout)
	pickup_timer.timeout.connect(_on_pickup_timer_timeout)

func _process(delta: float) -> void:
	update_camera_shake(delta)

func start_run() -> void:
	clear_entities()
	score = 0
	running = true
	shake_strength = 0.0

	camera.position = player_spawn.position
	camera.offset = Vector2.ZERO

	score_changed.emit(score)

	spawner.reset()
	spawn_player()
	spawn_pickup()

	spawner.start()
	score_timer.start()
	difficulty_timer.start()
	pickup_timer.start()
	show()

func stop_run() -> void:
	running = false
	spawner.stop()
	score_timer.stop()
	difficulty_timer.stop()
	pickup_timer.stop()
	clear_entities()
	camera.position = player_spawn.position
	camera.offset = camera_base_offset
	shake_strength = 0.0

func spawn_player() -> void:
	player = PLAYER_SCENE.instantiate()
	player.position = player_spawn.position
	entities.add_child(player)
	player.hit_hazard.connect(_on_player_hit_hazard)
	player.collected_pickup.connect(_on_player_collected_pickup)

func clear_entities() -> void:
	for child in entities.get_children():
		child.queue_free()

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)

func add_shake(amount: float) -> void:
	shake_strength = max(shake_strength, amount)

func update_camera_shake(delta: float) -> void:
	if shake_strength <= 0.01:
		camera.offset = camera_base_offset
		shake_strength = 0.0
		return

	camera.offset = camera_base_offset + Vector2(
		randf_range(-shake_strength, shake_strength),
		randf_range(-shake_strength, shake_strength)
	)
	shake_strength = lerp(shake_strength, 0.0, 8.0 * delta)

func _on_spawn_requested(spawn_position: Vector2, velocity: Vector2) -> void:
	if not running:
		return

	var hazard = HAZARD_SCENE.instantiate()
	hazard.position = spawn_position
	hazard.velocity = velocity
	entities.add_child(hazard)

func _on_score_timer_timeout() -> void:
	if running:
		add_score(1)

func _on_difficulty_timer_timeout() -> void:
	if running:
		spawner.ramp_difficulty()

func _on_pickup_timer_timeout() -> void:
	if running:
		spawn_pickup()

func spawn_pickup() -> void:
	var pickup = PICKUP_SCENE.instantiate()
	pickup.position = Vector2(
		randf_range(150.0, 1130.0),
		randf_range(150.0, 570.0)
	)
	entities.add_child(pickup)

func _on_player_hit_hazard() -> void:
	if not running:
		return

	running = false
	add_shake(12.0)
	Engine.time_scale = 0.35
	await get_tree().create_timer(0.12, true, false, true).timeout
	Engine.time_scale = 1.0

	spawner.stop()
	score_timer.stop()
	difficulty_timer.stop()
	pickup_timer.stop()
	run_ended.emit(score)

func _on_player_collected_pickup(pickup: Area2D) -> void:
	if not running:
		return

	if is_instance_valid(pickup):
		Juice.pulse_scale(player, 1.08, 0.05)
		add_shake(4.0)
		pickup.queue_free()

	add_score(5)
