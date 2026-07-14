extends Node3D

@export var boss:Enemy

var collone_list:Array[Marker3D]

func _ready() -> void:
	boss.process_mode = PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	$attack_spawn_marker.position = boss.position
	$attack_spawn_marker.look_at(position + Vector3.UP * 20)


func _on_area_3d_body_entered(body: Node3D) -> void:
	boss.player_in_attack_area = true
	boss.process_mode = PROCESS_MODE_INHERIT
