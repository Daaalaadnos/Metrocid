extends Node

var player:Player = null:
	set(value):
		player = value
		if is_instance_valid(player):
			SignalHub.player_initialized.emit(player)
