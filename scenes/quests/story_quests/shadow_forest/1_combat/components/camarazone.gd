extends Area2D
class_name CameraZone

@export var player_node: NodePath = NodePath("")   # arrastra tu Player aquí
@export var camera_node: NodePath = NodePath("")   # arrastra la Camera2D que quieres activar
@export var spawner_node: NodePath = NodePath("")  # arrastra tu Spawner (opcional)
@export var enemy_pattern_node: NodePath = NodePath("") # arrastra tu Patrón de Enemigo aquí

var _zone_camera: Camera2D
var _previous_camera: Camera2D
var _spawner: Node
var _enemy_pattern: Node

func _ready() -> void:
	_zone_camera = get_node(camera_node)
	_spawner = get_node_or_null(spawner_node)
	_enemy_pattern = get_node_or_null(enemy_pattern_node)

	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node) -> void:
	if body != get_node(player_node):
		return

	_previous_camera = get_viewport().get_camera_2d()
	_zone_camera.make_current()

	if _spawner:
		_spawner.call("start_spawning")

	# llamar al patrón usando los nombres que definimos en PatronDeEnemigo
	if _enemy_pattern:
		_enemy_pattern.call("start_spawning")

func _on_body_exited(body: Node) -> void:
	if body != get_node(player_node):
		return

	if _previous_camera and is_instance_valid(_previous_camera):
		_previous_camera.make_current()

	if _spawner:
		_spawner.call("stop_spawning")

	if _enemy_pattern:
		_enemy_pattern.call("stop_spawning")
