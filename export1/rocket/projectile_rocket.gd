extends Area3D

@onready var contact_ray_cast:RayCast3D = get_node('contact_ray_cast')

@onready var explosion_area:Area3D = get_node('explosion_area')
@onready var explosion_collison:CollisionShape3D = get_node('explosion_area/explosion_area_collision')

@onready var explosion_parent:Node3D = get_node('vfx/explosion_vfx')
@onready var fire_sparks_vfx:GPUParticles3D = get_node('vfx/fire_sparks_vfx')

@onready var rocket_mesh:MeshInstance3D = get_node('MeshInstance3D')

var exp_radius = 8
var SPEED := 10.0
var direction := Vector3.ZERO
var lifetime := 10.0
var damage := 1
var player_velocity:Vector3

var stop := false

var timer:float

func _ready():
	#_set_mask()
	explosion_collison.shape.radius = exp_radius / 2
	# Автоудаление через lifetime
	
	timer = lifetime

func _process(delta: float) -> void:
	timer -= delta
	
	if timer <= 0:
		queue_free()
	elif timer < lifetime / 4 and stop:
		stop = true
		explosion()

func _physics_process(delta):	
	if stop:
		return

	#global_translate(direction * SPEED * delta)
	#look_at(-direction * 100)

	var base_speed = direction * SPEED * delta
	#var projected = direction.normalized() * player_velocity.dot(direction.normalized()) * 0.8
	#var final_move = (base_speed + projected) * delta
	global_translate(base_speed)
	look_at(-direction * 100)
	
func explosion():
	if stop:
		return
	stop = true
	#print('rocket explosion call - ', name)
	fire_sparks_vfx.emitting = false
	make_damage()
	explosion_parent.set_vfx(true)
	rocket_mesh.visible = false

func make_damage():
	var bodys = explosion_area.get_overlapping_bodies()
	for body in bodys:
		var distans_to_body := global_transform.origin.distance_to(body.global_transform.origin)
		var exp_power_mod := 1.0
		if distans_to_body >= 1.5:
			exp_power_mod = clamp(1.0 - pow(distans_to_body / exp_radius,0.7 ), 0.0, 1.0)
		
		
		if body.is_in_group('enemy'):
			body.get_damage(damage * exp_power_mod / 2)
			#print('rocket damage - ',damage ,' mod - ', exp_power_mod, 'dist - ',distans_to_body)

		if body.is_in_group('player'):
			body.get_damage(damage * exp_power_mod)
			body.rocket_jump(global_transform.origin,exp_power_mod / 5)
			#print('rocket damage - ',damage ,' mod - ', exp_power_mod, 'dist - ',distans_to_body)
		
		if body.is_in_group('bomb'):
			body.explosion()
			
#func _set_mask():
	#await get_tree().create_timer(0.2).timeout
	#collision_mask  = (1 << 0) | (1 << 1) | (1 << 4) | (1 << 8)


func _on_body_entered(body: Node3D) -> void:
	explosion()
