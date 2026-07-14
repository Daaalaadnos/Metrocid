extends Node3D

class_name BulletVfx

@onready var body_cont:Node3D = get_node('body')

@onready var start_vfx_cont:Node3D = get_node('start_vfx')
@onready var live_vfx_cont:Node3D = get_node('life_vfx')
@onready var dead_vfx_cont:Node3D = get_node('dead_vfx')

func set_color(new_color:Color = Color(0.71, 0.686, 0.0, 0.549)) -> void:
	var mat:StandardMaterial3D = $body/MeshInstance3D.material_override
	mat.albedo_color = new_color

func _ready() -> void:
	set_vfx(start_vfx_cont,true)
	set_vfx(live_vfx_cont,true)

	#var tween:Tween = create_tween()
	#
	#tween.tween_property($body,'scale',Vector3.ONE * 2.5,0.5)

func dead() -> void:
	body_cont.hide()
	
	set_vfx(live_vfx_cont,false)
	set_vfx(dead_vfx_cont,true)

func set_vfx(cont:Node3D,new_status:bool) -> void:
	var vfx_array = cont.get_children()
	if vfx_array.size() <= 0:
		return
	
	for vfx in vfx_array:
		if vfx is GPUParticles3D:
			vfx.emitting = new_status
