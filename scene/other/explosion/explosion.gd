extends Node3D

@export var damage:float = 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play('explosion')

func start(new_scale,new_damage) -> void:
	for child in get_children():
		if child is GPUParticles3D:
			var a = child.process_material
			a.scale_min = new_scale
	$Area3D.scale *= new_scale
	damage = new_damage


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		SignalHub.emit_signal('playr_make_damage',damage)
	if body is Enemy:
		body.get_damage(damage)
		
	if "velocity" in body:
		body.velocity += global_position.direction_to(body.global_position) * (5.0 * scale.x)
	

func dead() -> void:
		call_deferred('queue_free')
