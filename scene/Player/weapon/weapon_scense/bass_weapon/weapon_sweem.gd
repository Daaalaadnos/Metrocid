extends Node
@onready var weapon_cont: Node3D = %anim_container

@export var noise:FastNoiseLite = FastNoiseLite.new()
@export var speed:float = 2.0
@export var noise_freq:float = 0.05
@export var sweem_amp:float = 10.0 
var noise_time:float 

@export var weapon_recoil_time:float = 1.0
var weapon_recoil_timer:float 

var weapon_recoil_power = Vector3.RIGHT

func _ready() -> void:
	noise.frequency = noise_freq


func _process(delta: float) -> void:
	recoil(delta)


func sweem_weapn(delta) -> void:
	noise_time += delta * speed
	
	var nise_x = noise.get_noise_2d(noise_time,0.0)
	var nise_y = noise.get_noise_2d(noise_time,100.0)
	
	weapon_cont.rotation_degrees.x = lerp(
		weapon_cont.rotation_degrees.x,
		nise_x * sweem_amp,
		delta)
	weapon_cont.rotation_degrees.y = lerp(
		weapon_cont.rotation_degrees.y,
		nise_y * sweem_amp,
		delta)

func weapon_recoil() -> void:
	weapon_recoil_timer = weapon_recoil_time

func recoil(delta) -> void:
	if weapon_recoil_timer >= 0:
		weapon_recoil_timer -= delta
		var t := 1.0 - (weapon_recoil_timer / weapon_recoil_time)
		var decay := 1.0 - t
		
		
		
		var offset = (weapon_recoil_power * 5.0) * decay #* $"..".WpRes.spred
		weapon_cont.rotation_degrees = lerp(weapon_cont.rotation_degrees,offset,delta * 20)
	else:
		weapon_cont.rotation_degrees = Vector3.ZERO
