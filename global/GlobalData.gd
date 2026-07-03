extends Node

var pl_res:PlRes = load('res://scene/Player/main/pl_res.tres')

var player:Player = null:
	set(value):
		player = value
		if is_instance_valid(player):
			SignalHub.player_initialized.emit(player)
