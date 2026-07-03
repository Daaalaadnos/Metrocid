extends Node

@onready var dash_restore_timer: Timer = %dash_restore_timer

var max_dash_count:int = 2
var dash_count:int = 0

var pl_cam:MainPlayerCamera:
		get:
			
			var active_cam = get_viewport().get_camera_3d()

			if active_cam is MainPlayerCamera:
				return active_cam
			
			return null

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

	if event.is_action_pressed('dash') and dash_count < max_dash_count:
		dash()

func dash() -> void:
	var input_dir := Input.get_vector('left', 'right', 'forward', 'backward')
	var direction := Vector3.ZERO
	
	# Если игрок жмет WASD — считаем направление от кнопок
	if input_dir != Vector2.ZERO:
		direction = (pl_cam.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	else:
		# Если ничего не нажато — дешимся строго вперед туда, куда смотрит камера
		direction = -pl_cam.global_transform.basis.z
	
	direction.y = 0.0
	direction = direction.normalized() # Повторно нормализуем после зануления Y
	
	# Сохраняем текущую вертикальную скорость игрока (падение или прыжок), чтобы не ломать гравитацию
	var current_y_velocity = player.velocity.y
	
	player.velocity = direction * 100.0
	dash_restore_timer.start()
	dash_count += 1
	
	await get_tree().create_timer(0.2).timeout
	
	# Возвращаем игроку физику: гасим горизонтальную скорость, но возвращаем скорость падения
	if is_instance_valid(player):
		player.velocity = Vector3(0, current_y_velocity, 0)

func _on_desh_restore_timer_timeout() -> void:
	dash_count = clampi(dash_count - 1,0,max_dash_count)
	
	if dash_count >0:
		dash_restore_timer.start()
