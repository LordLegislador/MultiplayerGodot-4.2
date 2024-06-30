extends Control

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene

#Cuando pulsas el boron creas el Host
func _on_host_button_pressed():
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	$EnterTo.hide()

#Añade el personaje a la partida(Server)
func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	player.global_position =Vector2(randi_range(-50,50),randi_range(-50,50))
	call_deferred("add_child",player)
	

#Te une como cliente al juego
func _on_join_button_pressed():
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer
	$EnterTo.hide()



