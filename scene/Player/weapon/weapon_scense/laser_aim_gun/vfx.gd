extends WeaponVFXManager

@onready var vfx_shot_spark: GPUParticles3D = %vfx_shot_spark
@onready var sparks: GPUParticles3D = %sparks


func shot() -> void:
	vfx_shot_spark.restart()
	sparks.restart()
