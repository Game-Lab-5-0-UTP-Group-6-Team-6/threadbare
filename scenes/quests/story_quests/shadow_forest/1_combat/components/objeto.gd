extends Node2D
class_name objectspawner1

@export var barrel_scene: PackedScene  # ← cambia el export a la escena del FillingBarrel
@export var lifetime: float = 15.0

var barrel_instance: Node = null

func spawn_enemy() -> void:
	if not barrel_scene:
		return

	# Instanciar y añadir el barril
	barrel_instance = barrel_scene.instantiate()
	get_tree().current_scene.add_child(barrel_instance)
	barrel_instance.global_position = global_position

	# Destruir después de X segundos
	await get_tree().create_timer(lifetime).timeout
	if barrel_instance and is_instance_valid(barrel_instance):
		barrel_instance.queue_free()
		barrel_instance = null
