extends Resource

class_name AbilityData

@export var id: String = "dash"          # Уникальный ID, чтобы искать в коде
@export var name: String = "Рывок"
@export var is_unlocked: bool = false
@export var ability_scene: PackedScene
