extends EC_Base

@export var areas:Array[Area3D]


func _ready() -> void:
	super._ready()
	for child in areas:
		child.body_entered.connect(_body_entered)
	

func _body_entered(body) -> void:
	enemy.pl_status_update(true)
	enemy_res.HP -= body.damage
	print(enemy.name,' less -  ', enemy_res.HP,' HP')
	
	if enemy_res.HP <= 0:
		enemy.dead()
