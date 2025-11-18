class_name SpawnEvent
extends Resource

@export var spawner: NodePath
@export var time: float
@export var repeat_interval: float = 0.0    # tiempo entre repeticiones
@export var repeat_count: int = 1           # cuántas veces se repite (1 = solo una vez)
