extends Node

class_name AbilityManager

@onready var aim_assist: AimAsistManager = %aim_assist

var inv:Abilityinventory


func _ready() -> void:
	inv = GlobalData.pl_res.inventory.ability_inventory
	
	add_ability()
	
	SignalHub.ability_unlocked.connect(_on_ability_unlocked)


func add_ability() -> void:
	var unlocked_ability = inv.get_unlock_ability()
	if unlocked_ability.size() <= 0:
		return
	
	for ability in unlocked_ability:
		if ability is AbilityData:
			if ability.is_unlocked:
				_spawn_ability(ability)
	

func _on_ability_unlocked(ability: AbilityData) -> void:
	_spawn_ability(ability)

func _spawn_ability(ability: AbilityData) -> void:
	if ability.ability_scene == null:
		return

	if has_node(ability.id):
		return
		
	var instance = ability.ability_scene.instantiate()
	instance.name = ability.id
	add_child(instance)
	instance.owner = self

func add_new_ability(new_ability) -> void:
	pass
