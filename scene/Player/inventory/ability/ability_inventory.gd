extends Resource

class_name Abilityinventory

@export var ability_list:Array[AbilityData]


func unlock_ability(new_ability: AbilityData) -> void:
	for ability in ability_list:
		if ability == new_ability:
			if !ability.is_unlocked:
				ability.is_unlocked = true
				SignalHub.ability_unlocked.emit(ability) # Сигнализируем, что нашли!
			return

func get_unlock_ability() -> Array[AbilityData]:
	var list:Array
	for ability in ability_list:
		if ability.is_unlocked:
			list.append(ability)
	return list
