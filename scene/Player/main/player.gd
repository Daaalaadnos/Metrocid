extends CharacterBody3D

class_name Player

var PR:PlRes

@onready var head:Node3D = get_node('head')

var hook_tween:Tween = null

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed('F1'):
		SignalHub.emit_signal('show_new_massage','jopa' + str(randf()))


func _ready() -> void:
	PR = GlobalData.pl_res
	GlobalData.player = self

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta #* 2.5

	# Handle jump.
	if Input.is_action_just_pressed('jump') and is_on_floor():
		$audio_player/player_jump.play()
		velocity.y = PR.jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector('left','right','forward','backward')
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x,direction.x * PR.speed ,delta * 30)
		velocity.z = move_toward(velocity.z,direction.z * PR.speed,delta * 30)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * 10)
		velocity.z = move_toward(velocity.z, 0, delta * 10)

	move_and_slide()

func jump_pad_impuls(impuls:Vector3) -> void:
	if hook_tween and hook_tween.is_valid():
		hook_tween.kill()
		hook_tween = null
	
	velocity = impuls

func add_loot(new_loot) -> void:
	PR.inventory.add_loot(new_loot)


func _on_step_timer_timeout() -> void:
	if velocity.length() >= 1 and is_on_floor():
		$Timers/step/AudioStreamPlayer.play()
