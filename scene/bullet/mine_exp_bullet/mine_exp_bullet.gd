extends BaseBullet

@export var explosion_scene:PackedScene

@export var explosion_delay:float = 2.0

func _ready() -> void:
	super._ready()
	$Node3D.visible = false
	$timers/explosion_timer.wait_time = randf_range(1,2)
	change_state(State.ATTACK)

func st_ph_attack(delta) -> void:

	velocity = velocity.move_toward(Vector3.ZERO, SPEED * delta * 0.5) 
	
	if !is_on_floor():
		velocity += get_gravity() * delta * 0.2
	else:
		change_state(State.FREEZ)
#
#func attack() -> void:
	#velocity = direction * SPEED

	var collision = move_and_collide(velocity)
	if collision:
		var collider = collision.get_collider()
		if collider is Player or collider is Enemy:
			explosion()
		change_state(State.FREEZ)
			#SignalHub.emit_signal('playr_make_damage',damage)


func freez() -> void:
	$timers/explosion_timer.start(explosion_delay)
	$Node3D.visible = true
	velocity = Vector3.ZERO

func st_freez(delta) -> void:
	if $timers/explosion_timer.is_stopped():
		explosion()

func explosion() -> void:
	if explosion_scene:
		var exp: = explosion_scene.instantiate()
		get_tree().current_scene.add_child(exp)
		exp.global_position = global_position
		exp.start(2.0,damage)
	else:
		push_error('mine dont have exp scene')
	call_deferred('queue_free')
