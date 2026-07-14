extends Node3D

@export var is_active:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_active:
		$Area3D.monitoring = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	$AnimationPlayer.play("open")
	$Timer.start()

func _on_area_3d_body_exited(body: Node3D) -> void:
	$AnimationPlayer.play_backwards("open")


func _on_timer_timeout() -> void:
	$AnimationPlayer.play_backwards("open")
