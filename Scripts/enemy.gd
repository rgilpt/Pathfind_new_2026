extends CharacterBody2D

@export var player: CharacterBody2D = null
@export var SPEED: float = 250.0
@export var distance_to_track: float = 70.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var perception: Area2D = $Perception

@onready var ray_cast_2d: RayCast2D = $RayCast2D

var player_in_range: bool = false
var I_see_player:bool = false

func _ready():
	perception.body_entered.connect(_on_body_entered)
	perception.body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	if body == player:
		player_in_range = true
		


func _on_body_exited(body):
	if body == player:
		player_in_range = false


func _physics_process(_delta):
	if player == null or not player_in_range:
		velocity = Vector2.ZERO
	else:
		if check_if_I_see_player():
			var point_to = player.global_position - self.global_position
			if point_to.length() > distance_to_track:
				velocity = point_to.normalized() * SPEED
			else:
				velocity = Vector2.ZERO
		if velocity.x < 0:
			sprite_2d.scale.x = -1
		elif velocity.x > 0:
			sprite_2d.scale.x = 1
	move_and_slide()

func check_if_I_see_player():
	ray_cast_2d.set_target_position(player.global_position - self.global_position)
	var collider = ray_cast_2d.get_collider()
	if collider == player:
		return true
	else:
		return false
		

	
