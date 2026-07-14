extends EC_Base

var move_chance:Array[ColoneBossAttack]

func _ready() -> void:
	move_chance = enemy.attack_list

func choose_next_move_by_weights() -> ColoneBossAttack:
	var total_weight:int
	var new_move:ColoneBossAttack
	for move in move_chance:
		total_weight += move.chance
	
	if total_weight <= 0:
		return null
	
	var rolled = randi() % total_weight
	var current_sum = 0
	for m in move_chance:
		current_sum += m.chance
		if rolled < current_sum:
			new_move = m

			#if enemy.stamina <= 0:
				#return 'rest'
			#else:
				#enemy.stamina -= (100 - move_weights[m]) / 2
			#
			return new_move
	return null
