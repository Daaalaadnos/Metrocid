extends Resource

class_name ColoneBossAttack

@export_category('main')
@export var attack_name:String
@export var move_time:int = 5
@export var chance:int = 20
@export var stamina_cost:float = 10.0

@export_category('jump')
@export var can_jump:bool = false
@export_range(0.1,1,0.1) var jump_time_mod:float
@export var max_jump_height:float = 10.0
@export_node_path('Node3D') var colone_marker

@export_category('shot')
@export var can_shot:bool = false
@export_flags('end_jump','midle_jump') var time_to_shot
@export var damage:int
@export var bullet_speed:float = 10
@export var spred:float
@export var fire_rait:float = 0.5
@export var bullet_in_shot:int = 1
@export var bullet_pull:int = 10
@export_node_path('Marker3D') var shot_marker
@export var bullet_scene:PackedScene
@export var bullet_visual:PackedScene
