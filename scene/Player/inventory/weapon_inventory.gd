extends Resource

class_name WeaponInventory

#@export var weapon_array:Array[WeaponRes]
@export var weapon_array:Array[WeaponResourse]

@export var weapon_slots:Array[WeaponSlot]# = [WeaponSlot.new(),WeaponSlot.new()]
var weapon_slot_id:int = 0


func get_weapon_from_slot(slot_id:int) -> WeaponResourse:##WeaponRes:
	if weapon_array.size() < slot_id:
		return null

	if !weapon_array[slot_id].weapon_stats.is_unlocked:
		return null

	return weapon_array[slot_id]

	#var activ_slots_quant:= 0
	#for slot in weapon_slots:
		#if slot.active:
			#activ_slots_quant += 1
#
	#slot_id = clamp(slot_id,0,activ_slots_quant -1)
	#var weapon_res := weapon_slots[slot_id].weapon_resurs
	#return weapon_res

func add_weapon(new_weapon:WeaponResourse) -> void:
	if new_weapon in weapon_array:
		return
	
	weapon_array.append(new_weapon)
	new_weapon.weapon_stats.is_unlocked = true

func set_weapon_in_slot(slot_id:int,selected_weapon_id:int) -> bool:
	if weapon_array.size() <= 0:
		return false
	var weapon = weapon_array[selected_weapon_id]
	if weapon.ammo_name !=	weapon_slots[slot_id].weapon_tipe:
		return false
	weapon_slots[slot_id].weapon_resurs = weapon
	return true

func get_activ_slot() -> int:
	var quantity := 0
	for slot in weapon_slots:
		if slot.active:
			quantity += 1
	return quantity
