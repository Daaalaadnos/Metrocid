extends BaseBullet


@onready var colone_boss_bullet_vfx_01: BulletVfx = $colone_boss_bullet_vfx01
@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D

var max_jump:int = 2
var jump:int = 0

var is_bouns:bool = false

func add_visual(vfx_scene:PackedScene = null) -> void:
	bullet_visual_scene = colone_boss_bullet_vfx_01
	bullet_visual_scene.set_color(Color(0.355, 0.368, 0.74, 1.0))

func st_ph_attack(delta) -> void:
	if not direction:
		return

	var motion: Vector3 = direction * SPEED * delta

	#shape_cast_3d.force_shapecast_update()
	
	#if shape_cast_3d.is_colliding():
		#var collider = shape_cast_3d.get_collider(0)
		#if collider == GlobalData.player:
			#SignalHub.emit_signal('playr_make_damage', damage)
			#change_state(State.DEAD)
			#return # Выходим, чтобы не было рикошета от игрока
		#
		#make_damage(collider)
		#
		#if !is_bouns:
			#change_state(State.DEAD)
			#return
		


	global_position += motion




	#var collision = move_and_collide(motion)

	#if collision:
		#var collider = collision.get_collider()
		#
		#if collider == GlobalData.player:
			#SignalHub.emit_signal('playr_make_damage', damage)
			#change_state(State.DEAD)
			#return # Выходим, чтобы не было рикошета от игрока
		#
		#make_damage(collider)
		#
		#if !is_bouns:
			#change_state(State.DEAD)
			#return
		#
		#
		## Рикошет: получаем нормаль поверхности и отражаем вектор направления
		#var normal: Vector3 = collision.get_normal()
		#direction = direction.bounce(normal).normalized()
		#jump += 1
		#
		## Если нужно, чтобы пуля визуально повернулась по новому направлению:
		## look_at(global_position + direction, Vector3.UP)
		#
		#if jump >= max_jump:	
			#change_state(State.DEAD)
