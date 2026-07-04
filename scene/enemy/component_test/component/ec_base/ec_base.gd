extends Node

class_name EC_Base

@onready var enemy:Enemy = get_parent()

var playe:Player

var enemy_res:EnemyRes:
	get: return enemy.enemy_res if enemy else null

var player: CharacterBody3D:
	get: return enemy.player if enemy else null

func _ready() -> void:
	enemy.sg_enemy_dead.connect(stop)
	
	
func stop() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
