extends Node3D

class_name BulletVfx

@onready var body_cont:Node3D = get_node('body')

@onready var start_vfx_cont:Node3D = get_node('start_vfx')
@onready var live_vfx_cont:Node3D = get_node('life_vfx')
@onready var dead_vfx_cont:Node3D = get_node('dead_vfx')

func _ready() -> void:
	set_vfx(start_vfx_cont,true)
	set_vfx(live_vfx_cont,true)

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
