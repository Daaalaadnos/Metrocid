extends Area3D

# Список наших волн (перетаскиваем узлы Wave1, Wave2 прямо сюда в инспекторе)
@export var waves: Array[Node3D] = []
@export var events:Array[Node3D] = []



var current_wave_index: int = 0
var alive_enemies_in_wave: int = 0
var player: Node3D = null

func _ready() -> void:
	# При старте сцены "выключаем" абсолютно все волны
	for wave in waves:
		wave.visible = false
		wave.process_mode = PROCESS_MODE_DISABLED
	#SignalHub._on_enemy_died.connect(_on_enemy_died)

func _on_body_entered(body: Node3D) -> void:
	if body is Player and current_wave_index == 0:
		print('a')
		player = body
		# Отключаем сам триггер, чтобы игрок прыжками не вызвал его снова
		collision_mask = 0 
		start_next_wave()
		update_events(true)

func start_next_wave() -> void:
	# Если волны закончились — арена пройдена
	if current_wave_index >= waves.size():
		print("Арена полностью зачищена!")
		update_events(false)
		call_deferred('queue_free') # Удаляем менеджер арены
		return
		
	var current_wave = waves[current_wave_index]
	
	# Будим волну (включаем видимость и физику/скрипты всех мобов внутри)
	current_wave.visible = true
	current_wave.process_mode = PROCESS_MODE_INHERIT
	
	# Считаем врагов в этой волне и подписываемся на их смерть
	var children = current_wave.get_children()
	alive_enemies_in_wave = children.size()
	
	for child in children:
		if child is BaseEnemyClass:
			# Подмешиваем игрока, чтобы они знали кого атаковать
			child.pl_status_update(true)  #wake_up(player, self) 
			
			child.sg_enemy_dead.connect(enemy_died)
			
	print("Старт волны №", current_wave_index + 1, ". Врагов: ", alive_enemies_in_wave)
	
	$Wave_spawn_pl.play()

func update_events(new_status:bool = false) -> void:
	for event in events:
		if event.has_method('update_event'):
			event.update_event(new_status)

func enemy_died() -> void:
	print(alive_enemies_in_wave)
	alive_enemies_in_wave -= 1
	
	# Если в текущей волне все мертвы — запускаем следующую
	if alive_enemies_in_wave <= 0:
		current_wave_index += 1
		# Небольшая задержка перед следующей волной, чтобы игрок перевёл дух
		get_tree().create_timer(2.0).timeout.connect(start_next_wave)
