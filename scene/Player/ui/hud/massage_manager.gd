extends Control

@export var massage_lable_scene:PackedScene

@onready var loot_masage_cont: VBoxContainer = $loot_masage_cont


func _ready() -> void:
	SignalHub.show_new_massage.connect(add_massage)

func add_massage(massage:String) -> void:
	
	var lable = massage_lable_scene.instantiate()
	lable.modulate.a = 0.0
	lable.text = massage
	loot_masage_cont.add_child(lable)
	fade_interact_label(lable,1.0,1.0)



func fade_interact_label(node: CanvasItem, target_alpha: float = 1.0, time: float = 0.5, pause_time: float = 1.0) -> void:
	var tween := create_tween()
	
	# Фейд к target_alpha
	tween.tween_property(node, "modulate:a", target_alpha, time)
	
	# Пауза на полной альфе
	tween.tween_interval(pause_time)
	
	# Фейд обратно к 0
	tween.tween_property(node, "modulate:a", 0.0, time)
	
	await tween.finished
	
	node.queue_free()
