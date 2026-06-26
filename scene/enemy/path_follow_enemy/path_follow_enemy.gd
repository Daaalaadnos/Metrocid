extends BaseEnemyClass


@export var path_follow:PathFollow3D

func _ready() -> void:
	super._ready()
	if !path_follow:
		push_warning(name,' path_follow == null')

func _process(delta: float) -> void:
	super._process(delta)
	
	if player_in_attack_area:
		return
	  
	if path_follow:
		path_follow.progress_ratio += delta * enemy_res.SPEED
		global_position.lerp(path_follow.global_position,delta)
