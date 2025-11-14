extends Node2D
class_name BasicSpawner

@export var enemy_scene: PackedScene
@export var lifetime: float = 15.0   # segundos antes de destruir al enemigo

var enemy_instance: Node = null

func spawn_enemy() -> void:
	if not enemy_scene:
		return
	
	# Instanciar y añadir el enemigo
	enemy_instance = enemy_scene.instantiate()
	get_tree().current_scene.add_child(enemy_instance)
	enemy_instance.global_position = global_position

	# --- 🔽 NUEVO BLOQUE: inicialización del enemigo ---
	# Asegurar que pertenezca al grupo correcto
	if not enemy_instance.is_in_group("CombatEnemy"):
		enemy_instance.add_to_group("CombatEnemy")

	# Llamar al método start() para que comience a atacar
	if enemy_instance.has_method("start"):
		enemy_instance.call("start")
	# --- 🔼 FIN DEL BLOQUE NUEVO ---

	# Destruir después de X segundos
	await get_tree().create_timer(lifetime).timeout
	if enemy_instance and is_instance_valid(enemy_instance):
		enemy_instance.queue_free()
		enemy_instance = null
