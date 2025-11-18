extends Node2D
class_name PatronDeEnemigo

@export var spawner_events: Array[SpawnEvent] = []
@export var total_duration: float = 120.0

var _running: bool = false


func _ready() -> void:
	pass


func start_spawning() -> void:
	if _running:
		return
	_running = true
	run_pattern()


func stop_spawning() -> void:
	_running = false


func run_pattern() -> void:
	spawner_events.sort_custom(func(a: SpawnEvent, b: SpawnEvent) -> bool:
		return a.time < b.time
	)

	for event in spawner_events:
		if event == null:
			continue
		_run_event(event)

	await get_tree().create_timer(total_duration).timeout
	_running = false


	# ⭐ Al finalizar el tiempo → ganar el minijuego
	var logic := get_tree().get_first_node_in_group("fill_game")
	if logic:
		logic.force_win()


func _run_event(event: SpawnEvent) -> void:
	await get_tree().create_timer(event.time).timeout
	if not _running:
		return

	var count := 0
	while _running:
		var s := get_node_or_null(event.spawner)
		if s and s.has_method("spawn_enemy"):
			s.spawn_enemy()

		count += 1
		if event.repeat_interval <= 0.0 or count >= event.repeat_count:
			break

		await get_tree().create_timer(event.repeat_interval).timeout
