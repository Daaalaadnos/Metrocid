extends Node3D

var direction:Vector3
var SPEED:float = 30.0


func _physics_process(delta: float) -> void:

	if not direction:
		return

	var motion: Vector3 = direction * SPEED * delta
	global_position += motion


func _on_timer_timeout() -> void:
	call_deferred('queue_free')
