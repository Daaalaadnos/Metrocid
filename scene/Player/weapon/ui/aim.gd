extends TextureRect

@onready var container: Node3D = %container
@onready var camera: Camera3D = get_viewport().get_camera_3d()


var start_pos:Vector2

func _ready() -> void:
	start_pos = position
	await get_tree().process_frame

func _process(delta: float) -> void:
	_update_aim_icon(delta)

func _update_aim_icon(delta) -> void:
	var target = owner.target_node
	
	position = start_pos
	
	if !is_instance_valid(target):
			return
	
		

	var screen_pos = camera.unproject_position(target.global_position)
	
	position = screen_pos - (size/2)

func update_scale_from_sprad(new_scale) -> void:
	scale = Vector2.ONE * new_scale
	set_anchors_preset(Control.PRESET_CENTER)
