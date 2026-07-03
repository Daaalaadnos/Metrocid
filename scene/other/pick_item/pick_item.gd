extends Area3D

@export var loot:Resource



func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.add_loot(loot)
		call_deferred('queue_free')
