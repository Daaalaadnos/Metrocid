extends Area3D

class_name HuckSphere

@export var target_marker:Node3D
var can_dash:bool = false

var dir:Vector3
var power:float


@export var is_enemy:bool = false
@export var HP = 20

@export var defolt_mat:StandardMaterial3D
@export var enemy_mat:StandardMaterial3D

const MUSICAL_STEPS = [0, 2, 4, 7, 9, 12]

func _ready() -> void:
	if target_marker:
		dir = global_position.direction_to(target_marker.global_position)
		power = global_position.distance_to(target_marker.global_position)
		can_dash = true

	if is_enemy:
		can_dash = false
		change_color(enemy_mat)
		#monitorable = false
	else:
		change_color(defolt_mat)
		$StaticBody3D.call_deferred('queue_free')

func change_color(new_mat:StandardMaterial3D) -> void:
	for child in $body_cont.get_children():
		if child is MeshInstance3D:
			child.material_override = new_mat.duplicate()

func play_huck_soung() -> void:
	#play_random_musical_sound($AudioStreamPlayer3D)
	$AudioStreamPlayer3D.play()

func play_random_musical_sound(audio_player: AudioStreamPlayer3D) -> void:
	# 1. Выбираем случайный шаг в полутонах из нашего списка
	var random_semitone: int = MUSICAL_STEPS.pick_random() - 32
	
	# Дополнительно: можно сделать легкий случайный сдвиг по октавам (-12 или 0)
	#random_semitone += [-12, -24].pick_random() 

	# 2. Считаем pitch_scale по формуле
	audio_player.pitch_scale = pow(2.0, random_semitone / 12.0)
	
	# 3. Играем звук
	audio_player.play()

func get_damage(damage):
	HP -= damage
	if HP <= 0:
		is_enemy = false
		can_dash = true
		change_color(defolt_mat)
		monitorable = true
		$StaticBody3D.call_deferred('queue_free')
	%dead.play()
	


func _on_body_entered(body: Node3D) -> void:
	if target_marker and can_dash:
		if body is CharacterBody3D and !is_enemy:
			body.jump_pad_impuls(dir * (power * 1.5))
