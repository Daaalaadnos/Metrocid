extends EC_Base


@export var weapon_array:Array[Node3D]

func _process(delta: float) -> void:
	if weapon_array.size() <= 0:
		return
	
	var target:Vector3 = player.global_position
	target.y += 1
	for weapon in weapon_array:
		weapon.look_at(target)
