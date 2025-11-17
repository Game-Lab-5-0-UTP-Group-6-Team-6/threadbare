class_name JasbHProjectile
extends Projectile

var sensor: Area2D
var sensor_shape: CollisionShape2D

func _ready() -> void:
	_set_color(color)
	_set_sprite_frames(sprite_frames)
	if trail_fx_scene:
		_trail_particles = trail_fx_scene.instantiate()
		trail_fx_marker.add_child(_trail_particles)
	duration_timer.wait_time = duration
	duration_timer.start()
	var pm := PhysicsMaterial.new()
	pm.bounce = 0.0
	physics_material_override = pm
	collision_layer = 0
	collision_mask = 0
	var impulse: Vector2 = direction * speed
	apply_impulse(impulse)
	_create_sensor()

func _create_sensor() -> void:
	sensor = Area2D.new()
	add_child(sensor)
	sensor.monitoring = true
	sensor.monitorable = true
	sensor_shape = CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 12
	sensor_shape.shape = circle
	sensor.add_child(sensor_shape)
	sensor.body_entered.connect(_on_sensor_body_entered)

func _physics_process(_delta: float) -> void:
	if sensor:
		sensor.global_position = global_position

func _on_sensor_body_entered(body: Node) -> void:
	if not is_instance_valid(body):
		return

	# barrels (por owner) — conservar lógica original
	if body.owner is FillingBarrel:
		add_small_fx()
		duration_timer.start()
		var filling_barrel: FillingBarrel = body.owner as FillingBarrel
		if filling_barrel.label == label:
			filling_barrel.increment()
			queue_free()
		return

	# jugador: simulamos la colisión enviando la señal al HitBox del player
	if body is Player or body.is_in_group("player"):
		if not can_hit_player:
			return

		# intentar emitir body_entered en el HitBox (comportamiento original)
		if body.has_node("HitBox"):
			var hb := body.get_node("HitBox")
			if hb:
				hb.call_deferred("emit_signal", "body_entered", self)
		else:
			# fallback: llamar got_hit del player si existe
			if body.has_method("got_hit"):
				body.call_deferred("got_hit", self)
		queue_free()
		return

	# todo lo demás -> atravesar (ignorar)
	return

func got_hit(player: Player) -> void:
	return
