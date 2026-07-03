extends Node3D

@onready var parent:CharacterBody3D = get_node("..")
@onready var head_camera: Camera3D = %head_camera
@onready var camera_cont : Node3D = get_node('cam_cont')

#камера
var sensetivity:float
@export var normal_sensetivity := 0.17
@export var aim_sensetivity := 0.1

var joy_sensetivity:float
@export var joy_normal_sensetivity := 110.17
@export var joy_aim_sensetivity := 90.1

@export var normal_fov := 75
@export var aim_fov := 60


var pitch := 0.0 #поворот камеры по Х
var yaw := 0.0 #поворот тела по Y
var max_pitch := 90 #ограничение вниз
var min_pitch := 86 #ограничение вверх

#параметры колебаний головы верх и вниз
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0


func _ready() -> void:
	
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)

	head_camera.fov = normal_fov
	sensetivity = normal_sensetivity

	joy_sensetivity = joy_normal_sensetivity

	
	#SignalManeger.shot_recoil.connect(camera_recoil)
	#SignalManeger.set_aim_mode.connect(set_aim_mode)
	#SignalManeger.set_after_teleport.connect(set_after_teleport)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		
		yaw -= event.relative.x * sensetivity
		pitch = clamp(pitch - event.relative.y * sensetivity, -min_pitch, max_pitch)
		
		yaw = wrapf(yaw, -360.0,360.0)
		pitch = clamp(pitch, -min_pitch, max_pitch)
	
		rotation_degrees.y = yaw
		camera_cont.rotation_degrees.x = pitch
	
	if event.is_action_pressed('F5'):
		if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_CAPTURED:
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		else:
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	
	#if Input.is_action_just_pressed('5'):
		#joy_sensetivity += 1
		#print(joy_sensetivity)
#
	#if Input.is_action_just_pressed('6'):
		#joy_sensetivity -= 1
		#print(joy_sensetivity)

	var joy_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var joy_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	
	# мёртвая зона, чтобы камера не дёргалась
	if abs(joy_x) < 0.15:
		joy_x = 0
	if abs(joy_y) < 0.15:
		joy_y = 0



	yaw -= joy_x * joy_sensetivity * delta
	pitch = clamp(pitch - joy_y * joy_sensetivity * delta, -min_pitch, max_pitch)

	yaw = wrapf(yaw, -360.0, 360.0)

	rotation_degrees.y = yaw
	camera_cont.rotation_degrees.x = pitch

	#качает головой при ходьбе
	t_bob += delta * parent.velocity.length() * float(parent.is_on_floor())
	camera_cont.transform.origin = _headbob(t_bob)

func _headbob(time) -> Vector3:#качает головой при ходьбе
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	
	#var pos_y = sin(time * BOB_FREQ) * BOB_AMP

	return pos
