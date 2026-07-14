extends Node3D

var Inv:WeaponInventory

@onready var head_camera:Camera3D = get_node('%head_camera')
@onready var weapon_container:Node3D = get_node('%weapon_cont')
@onready var aim_assist: AimAsistManager = %aim_assist

var curent_weapon_scene

var weapon_res

func _ready() -> void:
	Inv = GlobalData.pl_res.inventory.weapon_inventory
	
	set_weapon(0)

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed('1'):
		set_weapon(0)
	if event.is_action_pressed('2'):
		set_weapon(1)
	if event.is_action_pressed('3'):
		set_weapon(2)
	if event.is_action_pressed('4'):
		set_weapon(3)

	#if event.is_action_pressed('well_up') or event.is_action_pressed('well_down'):
		#change_weapon_well()

func _process(delta: float) -> void:
	global_transform = head_camera.global_transform

func set_weapon(id:int):

	if curent_weapon_scene and id == Inv.weapon_slot_id:
		return
	
	if id > Inv.get_activ_slot() - 1:
		return
	
	
	weapon_res = Inv.get_weapon_from_slot(id)
	if !weapon_res:# or weapon_res.weapon_stats.name == '':
		return
	var next_weapon_path = (weapon_res.weapon_scene)
	var new_weapon_scene = next_weapon_path.instantiate()
	weapon_container.add_child(new_weapon_scene)

	Inv.weapon_slot_id = id
	
	#weapon_container.hide()

	if curent_weapon_scene:
		curent_weapon_scene.queue_free()
	curent_weapon_scene = new_weapon_scene
	
	curent_weapon_scene.aim_assist = aim_assist
	
	await get_tree().create_timer(0.2).timeout
	#weapon_container.show()


func change_weapon_well():

	if Input.is_action_just_pressed('well_up'):
		set_weapon(wrapi(Inv.weapon_slot_id +1,0,Inv.get_activ_slot()))
	
	if Input.is_action_just_pressed('well_down'):
		set_weapon(wrapi(Inv.weapon_slot_id -1,0,Inv.get_activ_slot()))
