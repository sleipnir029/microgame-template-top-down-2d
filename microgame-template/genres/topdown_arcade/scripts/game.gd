extends Node2D

signal score_changed(value: int)
signal run_ended(final_score: int)

const PLAYER_SCENE := preload("res://genres/topdown_arcade/scenes/Player.tscn")
const HAZARD_SCENE := preload("res://genres/topdown_arcade/scenes/Hazard.tscn")
const PICKUP_SCENE := preload("res://genres/topdown_arcade/scenes/Pickup.tscn")

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var entities: Node2D = $Entities
@onready var spawner = $Spawner
@onready var score_timer: Timer = $ScoreTimer
@onready var difficulty_timer: Timer = $DifficultyTimer
@onready var pickup_timer: Timer = $PickupTimer

var player: Area2D
var score: int = 0
var running: bool = false

func _ready() -> void:
	visible = false
	spawner.spawn_requested.connect(_on_spawn_requested)
	score_timer.timeout.connect(_on_score_timer_timeout)
	difficulty_timer.timeout.connect(_on_difficulty_timer_timeout)
	pickup_timer.timeout.connect(_on_pickup_timer_timeout)

func start_run() -> void:
	clear_entities()
	score = 0
	running = true
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
	spawner.stop()
	score_timer.stop()
	difficulty_timer.stop()
	pickup_timer.stop()
	run_ended.emit(score)

func _on_player_collected_pickup(pickup: Area2D) -> void:
	if not running:
		return

	if is_instance_valid(pickup):
		pickup.queue_free()
	add_score(5)
