extends Resource

class_name PlayerInventory

@export var weapon_inventory:WeaponInventory
@export var ability_inventory:Abilityinventory


func add_loot(new_loot) -> void:
	
	if new_loot is AbilityData:
		ability_inventory.unlock_ability(new_loot)
		
		SignalHub.show_new_massage.emit(new_loot.name)
	
	if new_loot is WeaponResourse:
		weapon_inventory.add_weapon(new_loot)
		SignalHub.show_new_massage.emit(new_loot.weapon_stats.name)
