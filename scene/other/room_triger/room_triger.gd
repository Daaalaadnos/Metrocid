extends Area3D


func update_enemy(new_status) -> void:
	for child in get_children():
		if child is BaseEnemyClass:
			child.pl_status_update(new_status)



func _on_body_entered(body: Node3D) -> void:
	update_enemy(true)


func _on_body_exited(body: Node3D) -> void:
	update_enemy(false)
