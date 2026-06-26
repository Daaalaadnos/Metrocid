extends Resource

class_name WpInven

@export var inventory:Array[WeaponRes]


func get_weapon(id:int) -> WeaponRes:
	if id < 0 or id >= inventory.size(): return
	
	if !inventory[id].is_unlocked: return
	
	return inventory[id]
