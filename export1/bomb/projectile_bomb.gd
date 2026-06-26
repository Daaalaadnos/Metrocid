extends RigidBody3D


@onready var ray_cast_floor:RayCast3D = get_node('RayCast3D')

@onready var explosion_area:Area3D = get_node('explosion_area')
@onready var explosion_collison:CollisionShape3D = get_node('explosion_area/CollisionShape3D')

@onready var explosion_parent:Node3D = get_node('explosion_vfx')

@onready var granate_mesh:MeshInstance3D = get_node('MeshInstance3D')

@export var SPEED := 2.0
@export var lifetime := 5.0
@export var damage := 1
@export var exp_radius = 4

var player_impuls:Vector3
var direction := Vector3.ZERO

var floor_timer:float = 0.05
var is_on_floor:bool = false

var parent_player:bool = true


func _ready():
	_set_mask()
	explosion_collison.shape.radius = exp_radius
	#linear_velocity = (direction + Vector3(0,0.3,0)) * SPEED#  + player_impuls
	# Автоудаление через lifetime
	#print(linear_velocity,' ',direction,' ',SPEED)
	await get_tree().create_timer(lifetime).timeout
	explosion()

func start(new_dir:Vector3 = Vector3.ZERO,new_damage:int = 10) -> void:
	direction = new_dir
	linear_velocity = (direction + Vector3(0,0,0)) * SPEED

func _physics_process(delta: float) -> void:
	
	
	if ray_cast_floor.is_colliding():
		if is_on_floor:
			linear_damp = 2
		is_on_floor = true

	
	# Устанавливаем линейную скорость
	if linear_velocity.length() <= 1 and ray_cast_floor.is_colliding():
		freeze = true


func _process(delta: float) -> void:
	ray_cast_floor.global_transform.origin = global_transform.origin
	ray_cast_floor.target_position = Vector3(0,-0.15,0)

func explosion():
	make_damage()
	freeze = true
	granate_mesh.visible = false
	#explosion_parent.set_vfx(true)
	await get_tree().create_timer(1.0).timeout
	queue_free()

func make_damage():
	var bodys = explosion_area.get_overlapping_bodies()
	for body in bodys:
		var distans_to_body := global_transform.origin.distance_to(body.global_transform.origin)
		var exp_power_mod = clamp(1.0 - pow(distans_to_body / exp_radius,0.7 ), 0.0, 1.0)
		
		if body.is_in_group('enemy'):
			body.get_damage(damage * exp_power_mod)

		if body.is_in_group('player'):
			body.get_damage(exp_power_mod / 2)
			body.rocket_jump(global_transform.origin,exp_power_mod)

func _set_mask():
	await get_tree().create_timer(0.1).timeout
	collision_mask  = (1 << 0) | (1 << 1) | (1 << 4) | (1 << 8)

func get_damage(a):
	explosion()

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody3D:
		explosion()
