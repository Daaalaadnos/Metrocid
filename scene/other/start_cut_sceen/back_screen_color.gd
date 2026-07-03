extends ColorRect
#
## Скорость мигания
#@export var pulse_speed: float = 0.5
## Минимальная и максимальная прозрачность, чтобы мигание было легким
#@export var min_alpha: float = 0.05
#@export var max_alpha: float = 0.15
#
#var time: float = 0.0
#
#func _process(delta: float) -> void:
	#time += delta
	## Синус выдает от -1 до 1. Переводим это в диапазон от 0 до 1
	#var raw_sin = sin(time * pulse_speed)
	#var normalized_sin = (raw_sin + 1.0) / 2.0
	#
	## Смешиваем минимальную и максимальную прозрачность
	#self.color = lerp(Color(0.0, 0.0, 0.0, 1.0), Color(0.195, 0.0, 0.0, 1.0), normalized_sin)
