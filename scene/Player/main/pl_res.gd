extends Resource

class_name PlRes

@export_category('Main')
@export var MAX_HP:int = 100
var hp:float
@export var hp_restore_mod:float = 2.0
@export var MAX_SHILD:int = 100
var shild:float
@export var shild_restore_mod:float = 20.0
@export var shild_restore_delay:float = 1.5

@export var speed:float = 5.0
@export var jump_velocity:float = 4.5

@export_category('Inventory')
@export var inventory:PlayerInventory


@export_category('Other')
