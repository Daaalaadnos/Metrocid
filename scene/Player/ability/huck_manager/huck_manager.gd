extends Node

class_name Huck_Ability

@onready var desh_error: AudioStreamPlayer = $desh_error
@onready var huck_active: AudioStreamPlayer = %huck_active
@onready var dash_dalet_timer: Timer = %dash_dalet_timer


var aim_assist: AimAsistManager:
	get:
		# Если ссылка уже есть и она рабочая — просто отдаем её (работает мгновенно)
		if is_instance_valid(aim_assist):
			return aim_assist
		
		# Если ссылки нет (первый запуск) — безопасно ищем её у овнера
		if is_instance_valid(owner):
			aim_assist = owner.get("aim_assist")
		
		return aim_assist

var hook_tween:Tween

var player:Player
func _ready() -> void:

	if GlobalData.player != null:
		_on_player_ready(GlobalData.player)
	else:
		SignalHub.player_initialized.connect(_on_player_ready)

func _on_player_ready(player_ref: CharacterBody3D) -> void:
	player = player_ref

	if SignalHub.player_initialized.is_connected(_on_player_ready):
		SignalHub.player_initialized.disconnect(_on_player_ready)
		
	print("Враг ", name, " успешно нашел игрока!")

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed('alt shot'):
		if aim_assist:
			huck_node(aim_assist.get_huck_point())


func huck_node(target_point:HuckSphere) -> void:
	if not is_instance_valid(target_point):
			return
	
	if target_point.is_enemy:
		desh_error.play()
		return
	
	if !dash_dalet_timer.is_stopped():
		return
	dash_dalet_timer.start()
	huck_active.play()
	target_point.play_huck_soung()

	spawn_tracer(player.global_position,target_point.global_position)

	hook_tween = create_tween()
	
	hook_tween.set_trans(Tween.TRANS_QUAD)
	hook_tween.set_ease(Tween.EASE_OUT)
	
	hook_tween.tween_property(player,'global_position',target_point.global_position,0.5)
	hook_tween.finished.connect(func():
			pass
			player.velocity = Vector3.ZERO # Сбрасываем скорость после остановки
	)


func spawn_tracer(from: Vector3, to: Vector3):
	var tracer = MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.height = (from - to).length()
	mesh.top_radius = 0.25
	mesh.bottom_radius = 0.1
	tracer.mesh = mesh

	# поворот и позиция

	# материал
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = Color(0.878, 1.271, 1.572, 0.412)
	tracer.material_override = mat

	get_tree().current_scene.add_child(tracer)
	
	var dist = from.distance_to(to)
	var dir = from.direction_to(to)
	var midle_point = from + dir * (dist / 2) 

	tracer.look_at_from_position(midle_point, to)
	tracer.rotation_degrees.x += 90
	
	#анимация затухания
	var tw = fade_material(mat, 0.3)
	tw.tween_callback(func(): tracer.queue_free())

func fade_material(mat: StandardMaterial3D, duration: float = 0.3):
	var tw = create_tween()
	var c = mat.albedo_color
	tw.tween_method(
		func(value):
			c.a = value
			mat.albedo_color = c
	, 1.0, 0.0, duration)
	return tw
