extends Node

var PR:PlRes

func _ready() -> void:
	PR = GlobalData.pl_res
	SignalHub.playr_make_damage.connect(get_damage)

	PR.hp = PR.MAX_HP
	PR.shild = PR.MAX_SHILD
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if %shild_delay_timer.is_stopped():
		PR.shild = min(PR.shild + delta * PR.shild_restore_mod,PR.MAX_SHILD)
	PR.hp = min(PR.hp + delta * PR.hp_restore_mod,PR.MAX_HP)


func get_damage(damage) -> void:
	var damage_over_shild:float = PR.shild - damage
	PR.shild = max(damage_over_shild,0)
	
	if damage_over_shild < 0:

		PR.hp = max(PR.hp + damage_over_shild,0)
		
	%shild_delay_timer.start(PR.shild_restore_delay)
