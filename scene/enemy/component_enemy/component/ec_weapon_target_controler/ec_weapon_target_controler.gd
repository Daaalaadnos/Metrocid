extends EC_Base

@export var angle_restrictions:float = 45.0

@export var weapon_array:Array[Node3D]

func _process(delta: float) -> void:
	if weapon_array.size() <= 0:
		return
	
	if !is_instance_valid(player):
		return
	
	if !enemy.player_in_attack_area:
		return
	
	var target:Vector3 = enemy.to_local(player.position)
	
	target.y += 1
	
	for weapon in weapon_array:
		var dir_to_target:Vector3 = weapon.position.direction_to(target)
		
		var rot_y = atan2(-dir_to_target.x,-dir_to_target.z)
		weapon.rotation.y = lerp_angle(weapon.rotation.y,rot_y,delta * enemy_res.aim_speed_mod)
		
		var horizontal_dist = Vector2(dir_to_target.x, dir_to_target.z).length()
		var rot_x = atan2(dir_to_target.y, horizontal_dist)
		rot_x = clamp(rot_x, deg_to_rad(-angle_restrictions), deg_to_rad(angle_restrictions))
		weapon.rotation.x = lerp_angle(weapon.rotation.x, rot_x, delta * 5.0)
