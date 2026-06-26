extends Area3D

#@onready var forward_ray_cast:RayCast3D = get_node('forward_ray_cast')
#@onready var right_ray_cast:RayCast3D = get_node('right_ray_cast')
#@onready var left_ray_cast:RayCast3D = get_node('left_ray_cas')
@onready var floor_ray_cast:RayCast3D = get_node('floor_ray_cast')


@export var SPEED := 10.0
@export var GRAVITY := 20.0
@export var JUMP_STRENGTH := 5.0
var direction := Vector3.ZERO
var vertical_velocity: float = 0.0
var lifetime := 10.0
var damage := 1
var player_impuls:Vector3

var stop:bool = false


func _ready():
	# Автоудаление через lifetime
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta: float) -> void:
	if stop:
		return
	
	# Гравитация действует каждый кадр
	vertical_velocity -= GRAVITY * delta

	# Считаем общее движение (вперёд + по вертикали)
	var movement = direction.normalized() * SPEED * delta
	movement.y += vertical_velocity * delta

	global_translate(movement)

	# Направляем взгляд в сторону движения по XZ (игнорируя Y)
	var flat_direction = direction.normalized()
	flat_direction.y = 0
	if flat_direction.length_squared() > 0.001:
		look_at(global_position + movement.normalized())
	
	if floor_ray_cast.is_colliding():
		vertical_velocity = JUMP_STRENGTH
	
	#stop_ray_cast(forward_ray_cast)
	#stop_ray_cast(right_ray_cast)
	#stop_ray_cast(left_ray_cast)

func stop_ray_cast(ray_cast:RayCast3D) -> void:
	if ray_cast.is_colliding():
		#print(ray_cast)
		stop = true

#func _on_body_entered(body: Node3D) -> void:
	#if body.has_method('get_damage'):
		#body.get_damage(damage)
	#stop = true
#
#
#func _on_partial_damage_area_body_entered(body: Node3D) -> void:
	#if body.has_method('get_damage'):
		#body.get_damage(damage / 3)


func _on_area_entered(area: Area3D) -> void:
	if area.has_method('get_damage'):
		area.get_damage(damage)
	stop = true

func _on_partial_damage_area_area_entered(area: Area3D) -> void:
	if area.has_method('get_damage'):
		area.get_damage(damage / 3)
