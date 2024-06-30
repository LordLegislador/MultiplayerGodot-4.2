extends CharacterBody2D

#Indica la direccion a la que mira el personaje
enum DirectionState {Down,Left,Right,UP}
var DirectionAngle

#Velocidad a la que te mueves
@export var SPEED : float = 150.0

#Referenciamos la camara y el animatedsprite
@onready var Camera = get_node("Camera2D")
@onready var ASprite = get_node("AnimatedSprite2D")

#Damos la autoridad al jugador con el nombre(la id de conexion)
func _enter_tree():
	set_multiplayer_authority(name.to_int())

#Si el jugador tiene autoridad le añade la camara propia
func _ready():
	if is_multiplayer_authority():
		Camera.make_current()



func _physics_process(delta):
	if is_multiplayer_authority():
		var Dir = Input.get_vector("A","D","W","S")
		if Dir:
			velocity = Dir * SPEED
			rpc("_Sync_anim",Dir)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
			rpc("_Sync_anim_stop",Dir)
		move_and_slide()



@rpc("any_peer","call_local")
func _Sync_anim(Dir):
	match Dir:
		Vector2.DOWN:
			ASprite.play("WalkDown")
			DirectionAngle = DirectionState.Down
		Vector2.LEFT:
			ASprite.play("WalkLeft")
			DirectionAngle = DirectionState.Left
		Vector2.RIGHT:
			ASprite.play("WalkRight")
			DirectionAngle = DirectionState.Right
		Vector2.UP:
			ASprite.play("WalkUP")
			DirectionAngle = DirectionState.UP



@rpc("any_peer","call_local")
func _Sync_anim_stop(Dir):
	match DirectionAngle:
		DirectionState.Down:
			ASprite.play("default")
		DirectionState.Left:
			ASprite.play("defaultLeft")
		DirectionState.Right:
			ASprite.play("defaultRight")
		DirectionState.UP:
			ASprite.play("defaultUP")
