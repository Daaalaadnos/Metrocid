extends Resource

class_name WeaponStats
@export_category('main')
@export var name:String
@export var is_unlocked:bool = false

@export_category('weapon_stats')
@export var damage:float = 10
@export var fire_rate:float = 0.05
@export var bullet_in_shot:int = 1
@export var charge:bool = false
@export var charge_time:float = 1.5

@export_category('spred')
@export var max_spred:float = 10.0
@export var min_spred:float = 0.0
@export var spred_pre_shot:float = 1.5
@export var spred_damp_mod:float = 8.0
var spred:float

@export_category('aim_assist')
@export var aim_assist_power_mod:float = 20.0

@export_category('bullet_stats')
@export var bullet_scene:PackedScene
@export var bullet_vfx_scene:PackedScene
@export var bullet_speed:float = 30

@export_category('other')
@export_multiline var cnsole_massage:String
@export_multiline var disription:String
