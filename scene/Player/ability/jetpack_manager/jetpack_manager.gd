extends Node

@onready var fuel_bar: ProgressBar = %fuel_bar

# Настройки джетпака
@export var max_fuel: float = 100.0
@export var fuel_burn_rate: float = 30.0
@export var fuel_regen_rate_on_floor: float = 40.0
@export var fuel_regen_rate_in_fly: float = 5.0
@export var jetpack_force: float = 15.0

@export var max_up_speed:float = 5.0

var current_fuel: float

var player:Player
func _ready() -> void:

	if GlobalData.player != null:
		_on_player_ready(GlobalData.player)
	else:
		SignalHub.player_initialized.connect(_on_player_ready)

	current_fuel = max_fuel
	
	fuel_bar.max_value = max_fuel
	fuel_bar.value = current_fuel

func _on_player_ready(player_ref: CharacterBody3D) -> void:
	player = player_ref

	if SignalHub.player_initialized.is_connected(_on_player_ready):
		SignalHub.player_initialized.disconnect(_on_player_ready)
		
	print("Враг ", name, " успешно нашел игрока!")
	

func _physics_process(delta: float) -> void:
	# Проверяем условия для полета: зажат прыжок, мы в воздухе и есть топливо
	if Input.is_action_pressed('jump') and not player.is_on_floor() and current_fuel > 0.0:
		fly_up(delta)
	else:
		# Если не летим и стоим на земле — регеним топливо
		if player.is_on_floor():
			current_fuel = clampf(current_fuel + (fuel_regen_rate_on_floor * delta), 0.0, max_fuel)
		else:
			current_fuel = clampf(current_fuel + (fuel_regen_rate_in_fly * delta), 0.0, max_fuel)
	
	fuel_bar.value = current_fuel

func fly_up(delta: float) -> void:
	# 1. Тратим топливо (дельта гарантирует стабильный расход в секунду)
	current_fuel = clampf(current_fuel - (fuel_burn_rate * delta), 0.0, max_fuel)
	
	player.velocity.y = clampf(player.velocity.y + (jetpack_force * delta), -20.0, max_up_speed)
