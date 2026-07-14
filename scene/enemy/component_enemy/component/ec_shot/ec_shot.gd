extends EC_Base

@onready var fire_rite_timer: Timer = %Fire_rite_timer

@export var bullet_start_markers_area:Array[Marker3D]

func _ready() -> void:
	super._ready()
	fire_rite_timer.wait_time = enemy_res.fire_rite

func _process(delta: float) -> void:
	if player == null:
		return
	
	if !enemy.player_in_attack_area:
		return
	
	if fire_rite_timer.is_stopped():
		shot()
		fire_rite_timer.start()
		#print(enemy.name,' shot')

func shot() -> void:
	if enemy_res.bullet_res == null:
		return
	
	if bullet_start_markers_area.size() <= 0:
		push_error('bullet_marker_arrea = null')
		return
	
	for bullet_marker in bullet_start_markers_area:
		await get_tree().create_timer(randf_range(0.05,0.1)).timeout
	
		for a in range(enemy_res.bullet_in_shot):
	
			
			var bullet:BaseBullet = enemy_res.bullet_res.bullet_scene.instantiate()
			get_tree().current_scene.add_child(bullet)

			# Ставим пулю на дуло
			bullet.global_position = bullet_marker.global_position

			var direction: Vector3 = -bullet_marker.global_transform.basis.z
			var sprad_dir := direction
			sprad_dir = sprad_dir.rotated(Vector3.UP, deg_to_rad(randf_range(-enemy_res.spred_power,enemy_res.spred_power)))
			sprad_dir = sprad_dir.rotated(Vector3.RIGHT, deg_to_rad(randf_range(-enemy_res.spred_power,enemy_res.spred_power)))
			bullet.set_start(sprad_dir,enemy_res.bullet_res,player,true)
