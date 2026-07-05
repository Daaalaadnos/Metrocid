extends EC_Base

@export var areas:Array[Area3D]
@onready var body_cont: Node3D = $"../body_cont"


#func _ready() -> void:
	#super._ready()
	#for child in areas:
		#child.body_entered.connect(_body_entered)
	

func _body_entered(body) -> void:
	enemy.pl_status_update(true)
	if body is BaseBullet:
		enemy_res.HP -= body.damage

	body_cont.take_damage_flash()
	
	if enemy_res.HP <= 0:
		enemy.dead()
