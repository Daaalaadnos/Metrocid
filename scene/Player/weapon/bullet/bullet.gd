extends CharacterBody3D

class_name bass_bullet

const SPEED = 15.0
const JUMP_VELOCITY = 4.5

var direction:Vector3

var damage:int 

#func _init() -> void:
	#hide()

var is_dead:bool = false

func start(new_dir:Vector3,new_damage:int = 1) -> void:
	direction = new_dir
	velocity = direction * SPEED
	damage = new_damage


func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector3.ZERO
		return
	
	#if not is_on_floor():
		#print(get_gravity())
		#velocity += get_gravity() * delta * 5.0
	#else:
		#velocity = Vector3.ZERO
	#
	
	if direction:
		#velocity = direction * SPEED
		var collision = move_and_collide(direction)
		if collision:
			var collider = collision.get_collider()
			SignalHub.emit_signal('playr_make_damage',damage)
			#make_damage(collider)

			dead()
	move_and_slide()

func dead() -> void:
	is_dead = true
	$body_cont.hide()
	for node in $vfx.get_children():
		if node is GPUParticles3D:
			node.emitting = true
	await get_tree().create_timer(1.0).timeout
	call_deferred('queue_free')

func make_damage(enemy) -> void:
	if enemy.is_in_group('enemy'):
		if enemy.has_method('get_damage'):
			enemy.get_damage(damage)
	

func _on_life_time_timeout() -> void:
	if !is_dead:
		dead()

func _on_show_timer_timeout() -> void:
	show()


func _on_explosion_area_body_entered(body: Node3D) -> void:
	make_damage(body)
