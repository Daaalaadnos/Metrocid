extends Area3D

@export var target_marker:Marker3D
var dir:Vector3
var power:float

func _ready() -> void:
	if target_marker == null:
		monitoring = false
		return
	
	dir = global_position.direction_to(target_marker.global_position)
	power = global_position.distance_to(target_marker.global_position)



func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.velocity = dir * power
