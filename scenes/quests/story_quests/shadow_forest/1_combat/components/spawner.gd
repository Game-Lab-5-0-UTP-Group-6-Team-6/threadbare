extends Node2D

@export var circle_scene: PackedScene
@export var player_nodepath: NodePath
@export var spawn_interval: float = 5.0
@export var auto_stop_time: float = 75.0     # tiempo en segundos

var _player_node: Node2D
var _timer: Timer
var activo := false
var _auto_stop_timer: Timer

func _ready() -> void:
	_player_node = get_node(player_nodepath)

	_timer = Timer.new()
	_timer.wait_time = spawn_interval
	_timer.one_shot = false
	add_child(_timer)
	_timer.timeout.connect(_on_spawn_timeout)

	_auto_stop_timer = Timer.new()
	_auto_stop_timer.wait_time = auto_stop_time
	_auto_stop_timer.one_shot = true
	add_child(_auto_stop_timer)
	_auto_stop_timer.timeout.connect(_on_auto_stop)


func start_spawning() -> void:
	if activo:
		return
	activo = true
	_timer.start()
	_auto_stop_timer.start()


func stop_spawning() -> void:
	if not activo:
		return
	activo = false
	_timer.stop()
	_auto_stop_timer.stop()


func _on_spawn_timeout() -> void:
	if not activo:
		return
	if not _player_node or not circle_scene:
		return

	var circle_instance = circle_scene.instantiate()
	circle_instance.global_position = _player_node.global_position
	get_tree().current_scene.add_child(circle_instance)


func _on_auto_stop() -> void:
	stop_spawning()
