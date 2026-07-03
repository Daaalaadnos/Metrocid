extends Control

var PR:PlRes

@onready var hp_bar:ProgressBar = get_node('%hp_bar')
@onready var shild_bar:ProgressBar = get_node('%shild_bar')


func _ready() -> void:
	PR = GlobalData.pl_res

	PR.hp = PR.MAX_HP
	PR.shild = PR.MAX_SHILD
	
	hp_bar.max_value = PR.MAX_HP
	hp_bar.value = PR.MAX_HP
	shild_bar.max_value = PR.MAX_SHILD
	shild_bar.value = PR.MAX_SHILD

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	shild_bar.value = PR.shild
	
	hp_bar.value = PR.hp
