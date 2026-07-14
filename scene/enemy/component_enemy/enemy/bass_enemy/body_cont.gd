extends Node3D

@export var flash_color:Color = Color(1.0, 0.0, 0.0, 1.0)

var mash_cont:Array[CSGCombiner3D]

func _ready() -> void:
	
	for child in get_children():
		if child is CSGCombiner3D:
			mash_cont.append(child)

func take_damage_flash() -> void:
	if mash_cont.size() <= 0:
		return
	
	for child in mash_cont:
		tween_flash(child)


func tween_flash(node:CSGCombiner3D) -> void:

	var tween := create_tween()
	
	var mat = node.material_overlay as StandardMaterial3D
	var bass_color:Color = mat.albedo_color
		
	if mat:
		tween.tween_property(mat, "albedo_color", flash_color, 0.05)
		tween.tween_property(mat, "albedo_color", Color(1.0, 1.0, 1.0, 0.0), 0.3)
	
