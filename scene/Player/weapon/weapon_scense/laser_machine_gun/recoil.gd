extends Node

var WpRes:WeaponStats

@onready var cont_1: Node3D = $"../container/anim_container/cont1"
@onready var cont_2: Node3D = $"../container/anim_container/cont2"


@export var weapon_recoil_time:float = 1.0
var weapon_recoil_timer:float 
@export var weapon_recoil_power:float = 1.0
@export var recoil_curve:Curve
@export var recoil_curve2:Curve

func _ready() -> void:
	WpRes = owner.WpRes

func _process(delta: float) -> void:
	recoil(delta)

func recoil_update() -> void:
	weapon_recoil_timer = weapon_recoil_time

func recoil(delta) -> void:
	if weapon_recoil_timer >= 0:
		weapon_recoil_timer -= delta
		var t := 1.0 - (weapon_recoil_timer / weapon_recoil_time)
		#var decay := 1.0 - t
		
		
		
		var offset = recoil_curve.sample(t) * weapon_recoil_power#(weapon_recoil_power * 5.0) * decay #* $"..".WpRes.spred
		cont_1.position.z = lerp(cont_1.position.z,offset,delta * 20.0)
		offset = recoil_curve2.sample(t) * weapon_recoil_power
		cont_2.position.z = lerp(cont_2.position.z,offset,delta * 20.0)
	#else:
		#csg_combiner_3d_2.rotation_degrees = Vector3.ZERO
