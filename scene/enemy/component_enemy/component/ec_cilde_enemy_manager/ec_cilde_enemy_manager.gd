extends EC_Base

@export var child_enemy:Array[Enemy]

var player_status:bool = false

func _process(delta: float) -> void:

	pl_status_update() 


func pl_status_update() -> void:

	#можно было и сигналом но мне похуй	
	if player_status == enemy.player_in_attack_area:
		return
	player_status = enemy.player_in_attack_area
	
	if child_enemy.size() <= 0:
		return

	child_enemy = child_enemy.filter(func(child): return is_instance_valid(child))
	for child in child_enemy:

		if child is Enemy:
			child.pl_status_update(player_status)
