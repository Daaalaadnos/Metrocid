extends TextureRect

@onready var weapon_cont:Node3D = get_node("%weapon_cont")
@onready var camera: Camera3D = %head_camera.get_viewport().get_camera_3d()
@onready var wepon:Node3D = get_node('%weapon')


var start_pos:Vector2

func _ready() -> void:
	start_pos = get_window().size
	await get_tree().process_frame

func _process(delta: float) -> void:
	
	_update_aim_icon(delta)

func _update_aim_icon(delta) -> void:
	if not is_instance_valid(camera):
			return
		
	position = start_pos
	var dir := -weapon_cont.global_transform.basis.z
	var pos = weapon_cont.global_position + dir * 50
	var screen_pos = camera.get_viewport().get_camera_3d().unproject_position(pos)
	
	position = screen_pos - (size/2)
	#visible = shot_ray_cast.is_colliding()

func update_scale_from_sprad(new_scale) -> void:
	scale = Vector2.ONE * new_scale
