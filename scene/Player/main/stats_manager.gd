extends Node

@onready var hp_bar:ProgressBar = get_node('%hp_bar')
@onready var shild_bar:ProgressBar = get_node('%shild_bar')

@export var MAX_HP:int = 100
var hp:float
@export var hp_restore_mod:float = 2.0
@export var MAX_SHILD:int = 100
var shild:float
@export var shild_restore_mod:float = 20.0
@export var shild_restore_delay:float = 1.5

func _ready() -> void:
	SignalHub.playr_make_damage.connect(get_damage)

	hp = MAX_HP
	shild = MAX_SHILD
	
	hp_bar.max_value = MAX_HP
	hp_bar.value = MAX_HP
	shild_bar.max_value = MAX_SHILD
	shild_bar.value = MAX_SHILD

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if %shild_delay_timer.is_stopped():
		shild = min(shild + delta * shild_restore_mod,MAX_SHILD)
	hp = min(hp + delta * hp_restore_mod,MAX_HP)
	
	if shild < MAX_SHILD:
		shild_bar.value = shild
	
	if hp < MAX_HP:
		hp_bar.value = hp

func get_damage(damage) -> void:
	var damage_over_shild:float = shild - damage
	shild = max(damage_over_shild,0)
	
	if damage_over_shild < 0:

		hp = max(hp + damage_over_shild,0)
		
	%shild_delay_timer.start(shild_restore_delay)

#func change_hp_bar_color(new_color) -> void:
		#var sb = hp_bar.get_theme_stylebox("fill", "ProgressBar")
		#
		## 2. Обязательно делаем дубликат! 
		## Иначе ты изменишь цвет вообще у ВСЕХ ProgressBar в игре, использующих этот ресурс.
		#var unique_sb = sb.duplicate()
		#
		## 3. Меняем цвет (принимает объект Color)
		#unique_sb.bg_color = new_color
		#
		## 4. Записываем измененный stylebox обратно в этот конкретный узел как локальный оверрайд
		#hp_bar.add_theme_stylebox_override("fill", unique_sb)
