extends CharacterBody3D

class_name Player

@onready var head:Node3D = get_node('head')

@export var SPEED = 10.0
@export var JUMP_VELOCITY = 4.5

func _ready() -> void:
	GlobalData.player = self
	%UI_SubViewport.size = get_viewport().get_window().size

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta #* 2.5

	# Handle jump.
	if Input.is_action_just_pressed('jump') and is_on_floor():
		$audio_player/player_jump.play()
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector('left','right','forward','backward')
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x,direction.x * SPEED,delta * 30)
		velocity.z = move_toward(velocity.z,direction.z * SPEED,delta * 30)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * 10)
		velocity.z = move_toward(velocity.z, 0, delta * 10)

	move_and_slide()

@export var bass_huck_impuls_forse:float = 30.5
var hook_tween:Tween = null

func huck_node(target_point:HuckSphere) -> void:
	if not is_instance_valid(target_point):
			return
	
	if target_point.is_enemy:
		%desh_error.play()
		return
	
	if !%dash_dalet_timer.is_stopped():
		return
	%dash_dalet_timer.start()
	$audio_player/player_dash.play()
	target_point.play_huck_soung()

	spawn_tracer(global_position,target_point.global_position)

	hook_tween = create_tween()
	
	hook_tween.set_trans(Tween.TRANS_QUAD)
	hook_tween.set_ease(Tween.EASE_OUT)
	
	hook_tween.tween_property(self,'global_position',target_point.global_position,0.5)
	hook_tween.finished.connect(func():
			pass
			velocity = Vector3.ZERO # Сбрасываем скорость после остановки
	)

func jump_pad_impuls(impuls:Vector3) -> void:
	if hook_tween and hook_tween.is_valid():
		hook_tween.kill()
		hook_tween = null
	
	velocity = impuls

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
	mat.albedo_color = Color(0.878, 1.133, 1.572, 0.412)
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

func _on_step_timer_timeout() -> void:
	if velocity.length() >= 1 and is_on_floor():
		$Timers/step/AudioStreamPlayer.play()
