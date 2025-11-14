extends Area2D

@export var animacion: AnimatedSprite2D
@export var TiempoParaActivar: float = 2.0
@export var TiempoActivo: float = 1.5

var _state: String = "idle"
var _timer: float = 0.0

func _ready() -> void:
	monitoring = false
	$CollisionShape2D.disabled = true
	connect("body_entered", Callable(self, "_on_body_entered"))
	if animacion:
		animacion.play("activacion")

func _process(delta: float) -> void:
	_timer += delta
	match _state:
		"idle":
			if _timer >= TiempoParaActivar:
				_activate()
		"active":
			if _timer >= TiempoParaActivar + TiempoActivo:
				_deactivate()

func _activate() -> void:
	_state = "active"
	monitoring = true
	$CollisionShape2D.disabled = false
	if animacion:
		animacion.play("activado")

func _deactivate() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if _state != "active":
		return
	if not body:
		return

	# buscar el ancestro que esté en el grupo "player"
	var p: Node = body
	while p and not p.is_in_group("player"):
		p = p.get_parent()
	if not p:
		return

	var pf := p.get_node_or_null("PlayerFighting")
	if not pf:
		return

	# crear instancia de Projectile y pasarla al handler del jugador
	if typeof(Projectile) != TYPE_NIL:
		var proj := Projectile.new()
		pf._on_body_entered(proj)
