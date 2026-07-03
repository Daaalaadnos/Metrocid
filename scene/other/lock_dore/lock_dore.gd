extends StaticBody3D

func _ready() -> void:
	update_event(false)


func update_event(new_status: bool = false) -> void:
	# Если true — прозрачность 1.0 (виден), если false — 0.0 (невиден)
	tween_change_transparency(1.0 if new_status else 0.0)
	
	
	$CollisionShape3D.disabled = not new_status

func tween_change_transparency(new_value: float = 1.0) -> void:
	var mat = $MeshInstance3D.material_override as ShaderMaterial
	if mat:
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_BOUNCE)
		# Твиним напрямую альфу внутри вектора bass_color
		tween.tween_property(mat, "shader_parameter/bass_alpha", new_value, 0.5)
