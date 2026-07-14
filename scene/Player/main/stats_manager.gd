extends Node

var PR:PlRes



func _ready() -> void:
	PR = GlobalData.pl_res
	SignalHub.playr_make_damage.connect(get_damage)

	PR.hp = PR.MAX_HP
	PR.shild = PR.MAX_SHILD
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if %shild_delay_timer.is_stopped() and PR.shild < PR.MAX_SHILD:
		PR.shild = min(PR.shild + delta * PR.shild_restore_mod,PR.MAX_SHILD)
		if PR.shild >= PR.MAX_SHILD:
			SignalHub.show_sistem_massage.emit(tr('Shild full'))
	PR.hp = min(PR.hp + delta * PR.hp_restore_mod,PR.MAX_HP)


func get_damage(damage) -> void:
	var damage_over_shild:float = PR.shild - damage
	PR.shild = max(damage_over_shild,0)
	
	if damage_over_shild < 0:
		PR.hp = max(PR.hp + damage_over_shild,0)
		#var damage_massage:String = 
		SignalHub.show_sistem_massage.emit(tr('Shild is broken\nBody take - ' + str(damage) + 'damage'))
	else:
		SignalHub.show_sistem_massage.emit(tr('Shild take - ' + str(damage) + 'damage'))
		
	%shild_delay_timer.start(PR.shild_restore_delay)


func _on_take_damage_area_body_entered(body: Node3D) -> void:
	if body is BaseBullet:
		get_damage(body.damage)


func _on_shild_delay_timer_timeout() -> void:
	SignalHub.show_sistem_massage.emit(tr('Shild restor started'))
