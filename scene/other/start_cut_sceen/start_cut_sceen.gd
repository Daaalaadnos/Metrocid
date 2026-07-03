extends Node

@onready var console_container: VBoxContainer = %console_container


# Перетащи сюда сцену console_line.tscn в инспекторе
@export var line_scene: PackedScene 

# Простой массив строк
var system_messages: Array[String] = [
	"Инициализация системы...",
	"Проверка модулей ядра...",
	"ВНИМАНИЕ: Обнаружен неопознанный протокол!", # Эту строку покрасим в коде
	"Очистка кэша завершена."
]

func _ready():
	run_console()

func run_console():
	for message in system_messages:
		# Создаем новую строчку из сцены
		var new_line = line_scene.instantiate() as Label
		console_container.add_child(new_line)
		
		# ПРИМЕР: Если строка содержит слово "ВНИМАНИЕ", красим её в красный
		if "ВНИМАНИЕ" in message:
			new_line.modulate = Color.RED
			# Можно сделать паузу ПЕРЕД важной строкой
			await get_tree().create_timer(0.5).timeout 
		
		# Запускаем печать текста и ждем её окончания
		await new_line.animate_text(message)
		
		# Пауза после печати строки перед переходом к следующей
		await get_tree().create_timer(0.3).timeout
		
		# Удаляем старые строки, чтобы консоль не росла бесконечно
		if console_container.get_child_count() > 10:
			console_container.get_child(0).queue_free()
