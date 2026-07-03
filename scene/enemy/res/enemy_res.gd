extends Resource

class_name EnemyRes

@export_category('main')
@export var HP:int = 10
@export var SPEED:float = 5.0

@export_category('dash')
@export var dead_time:float = 5.0
@export var dash_power:float = 5.0
@export var damp_mod:float = 3.0

@export_category('weapon')
@export var bullet_scene:PackedScene
@export var bullet_res:BulletPatam
@export var damage:int = 10
@export var fire_rite:float = 1.0
@export var bullet_in_shot:int = 1
@export var spred_power:float = 2.0
