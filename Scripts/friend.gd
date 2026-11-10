extends CharacterBody2D

@export var player: CharacterBody2D = null
@export var SPEED: float = 250.0
@export var distance_to_track: float = 70.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var perception: Area2D = $Perception
@onready var ray: RayCast2D = $RayCast2D

var player_in_range: bool = false


func _ready():
	perception.body_entered.connect(_on_body_entered)
	perception.body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	if body == player:
		player_in_range = true


func _on_body_exited(body):
	if body == player:
		player_in_range = false


func _can_see_player() -> bool:
	if player == null:
		return false
	ray.target_position = ray.to_local(player.global_position)
	ray.force_raycast_update()
	return ray.is_colliding() and ray.get_collider() == player


func _physics_process(_delta):
	if not player_in_range or not _can_see_player():
		velocity = Vector2.ZERO
	else:
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
