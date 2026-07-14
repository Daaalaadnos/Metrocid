extends Control

@export var massage_lable_scene:PackedScene

@onready var ivent_console: VBoxContainer = $ivent_console
@onready var sistem_consol: VBoxContainer = $sistem_consol


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('F1'):
		SignalHub.emit_signal('show_new_massage','jopa')
		SignalHub.emit_signal('show_sistem_massage','jopa')

func _ready() -> void:
	SignalHub.show_new_massage.connect(ivent_massage)
	SignalHub.show_sistem_massage.connect(sistem_massage)

func ivent_massage(massage:String) -> void:
	add_massage(massage,ivent_console)

func sistem_massage(massage:String) -> void:
	add_massage(massage,sistem_consol)


func add_massage(massage:String,container:VBoxContainer) -> void:
	var new_line = massage_lable_scene.instantiate() as Label
	container.add_child(new_line)

	await new_line.animate_text(massage)

	if container.get_child_count() > 10:
		container.get_child(0).queue_free()
		return
