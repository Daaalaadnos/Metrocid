extends WeaponVFXManager
@onready var sparks: GPUParticles3D = %sparks
@onready var plasm_shot_wave: GPUParticles3D = $plasm_shot_wave



func shot() -> void:
	sparks.restart()
	plasm_shot_wave.emitting = true

func idle() -> void:
	plasm_shot_wave.emitting = false
