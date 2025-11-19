extends Area2D
class_name CameraZone

@export var player_node: NodePath = NodePath("")   # arrastra tu Player aquí
@export var camera_node: NodePath = NodePath("")   # arrastra la Camera2D que quieres activar
@export var spawner_node: NodePath = NodePath("")  # arrastra tu Spawner (opcional)
@export var enemy_pattern_node: NodePath = NodePath("") # arrastra tu Patrón de Enemigo aquí

@export var blocker_node: NodePath = NodePath("")  # StaticBody2D o CollisionShape2D (opcional)

var _zone_camera: Camera2D
var _previous_camera: Camera2D
var _spawner: Node
var _enemy_pattern: Node
var _blocker: Node

func _ready() -> void:
	_zone_camera = get_node_or_null(camera_node)
	_spawner = get_node_or_null(spawner_node)
	_enemy_pattern = get_node_or_null(enemy_pattern_node)
	_blocker = get_node_or_null(blocker_node)

	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

	_disable_blocker() # empieza desactivado


func _on_body_entered(body: Node) -> void:
	if body != get_node(player_node):
		return

	_previous_camera = get_viewport().get_camera_2d()
	if is_instance_valid(_zone_camera):
		_zone_camera.make_current()

	if _spawner:
		_spawner.call("start_spawning")

	if _enemy_pattern:
		_enemy_pattern.call("start_spawning")

	_enable_blocker()


func _on_body_exited(body: Node) -> void:
	if body != get_node(player_node):
		return

	if _previous_camera and is_instance_valid(_previous_camera):
		_previous_camera.make_current()

	if _spawner:
		_spawner.call("stop_spawning")

	if _enemy_pattern:
		_enemy_pattern.call("stop_spawning")


func _enable_blocker():
	if not _blocker or not is_instance_valid(_blocker):
		return

	if _blocker is CollisionShape2D:
		_blocker.set_deferred("disabled", false)
		return

	if _blocker is StaticBody2D:
		for child in _blocker.get_children():
			if child is CollisionShape2D:
				child.set_deferred("disabled", false)
		return

	# fallback: intentar con propiedades
	if _blocker.has_method("set_deferred"):
		_blocker.set_deferred("collision_layer", 1)
		_blocker.set_deferred("collision_mask", 1)


func _disable_blocker():
	if not _blocker or not is_instance_valid(_blocker):
		return

	if _blocker is CollisionShape2D:
		_blocker.set_deferred("disabled", true)
		return

	if _blocker is StaticBody2D:
		for child in _blocker.get_children():
			if child is CollisionShape2D:
				child.set_deferred("disabled", true)
		return

	# fallback
	if _blocker.has_method("set_deferred"):
		_blocker.set_deferred("collision_layer", 0)
		_blocker.set_deferred("collision_mask", 0)
