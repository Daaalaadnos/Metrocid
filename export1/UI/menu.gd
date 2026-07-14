#extends Control
#
#@export var inventory:PlayerInventory
#@export var _theme:Theme
#
#@onready var weapon_slot_cont:HBoxContainer = get_node('%weapon_slots_cont')
#@onready var weapon_list:VBoxContainer = get_node('%weapon_list')
#@onready var wrong_weapon_masage:CenterContainer = get_node('%wrong_wepon_masge')
#
#@onready var menu_weapon_mesh:MeshInstance3D = get_node('%menu_weapon_mesh')
#@onready var weapon_name_d:Label = get_node('%weapon_name_d')
#@onready var weapon_disc:RichTextLabel = get_node('%weapon_discription')
#
#var menu_is_opern:bool
#
#var selected_weapon_id:int
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#visible = menu_is_opern
	#wrong_weapon_masage.modulate.a = 0.0
	##menu_weapon_mesh.hide() #.mesh = inventory.weapon_array[inventory.weapon_id].weapon_mesh
#
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed('esc'):
		#menu_is_opern = !menu_is_opern
		#visible = menu_is_opern
		#PlayerData._set_mouse_mode(menu_is_opern)
		#
		#if menu_is_opern:
			#weapon_list_update()
			#weapon_slot_btn_update()
#
#func weapon_slot_btn_update() -> void:
	#var def_btn:Button
	#for child in weapon_slot_cont.get_children():
		#def_btn = child.duplicate()
		#child.queue_free()
#
	#for i in inventory.weapon_slots.size():
		#var btn = Button.new()
		#btn = def_btn.duplicate()
		#btn.theme = _theme
		#btn.text = inventory.weapon_slots[i].weapon_tipe
		#btn.pressed.connect(_weapon_set_in_slot.bind(i))
		#weapon_slot_cont.add_child(btn)
#
		#if !inventory.weapon_slots[i].active:
			#btn.disabled = true
		#else :
			#btn.disabled = false
#
#func weapon_list_update() -> void:
	#for child in weapon_list.get_children():
		#child.queue_free()
#
	#for i in inventory.weapon_array.size():
		#var btn = Button.new()
		#btn.theme = _theme
		#btn.text = inventory.weapon_array[i].weapon_name
		#btn.pressed.connect(_weapon_selected_in_list.bind(i))
		#weapon_list.add_child(btn)
		#weapon_list.queue_sort()
		#btn.grab_focus()
		#btn.focus_mode = Control.FOCUS_ALL
#
#func _weapon_selected_in_list(id:int) -> void:
	#selected_weapon_id = id
	#discription_update(id)
#
#func _weapon_set_in_slot(slot_id:int) -> void:
	#if !inventory.set_weapon_in_slot(slot_id,selected_weapon_id):
			#fade_masage(wrong_weapon_masage,1.0,0.5)
			#await get_tree().create_timer(2.0).timeout
			#fade_masage(wrong_weapon_masage,0.0,0.5)
#
#func discription_update(id:int) -> void:
	#var weapon_r := inventory.weapon_array[id]
	#menu_weapon_mesh.mesh = weapon_r.weapon_mesh
	#weapon_name_d.text = weapon_r.weapon_name
	#var desc := [
		#"Class: %s" % weapon_r.ammo_name,
		#"Damage: %s" % weapon_r.damage,
		#"Crit x%s" % weapon_r.crit_multiplier,
		#"Pellets: %s" % weapon_r.bullet_quantity_in_shot,
		#"Scatter: %s°" % weapon_r.max_scatter,
		#"Magazine: %s" % weapon_r.magazine_size,
		#"Ammo: %s" % weapon_r.ammo_name,
	#]
#
	#weapon_disc.text = "\n".join(desc)
#
#func fade_masage(node:CanvasItem ,target_alpha: float, time: float = 0.5):
	#var tween := create_tween()
	#tween.tween_property(node, "modulate:a", target_alpha, time)
