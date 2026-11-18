extends CharacterBody2D

@export var player: CharacterBody2D = null
@export var movement_speed: float = 250.0

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(_delta):
	if player == null:
		return
	nav.target_position = player.global_position
	if nav.is_navigation_finished():
		velocity = Vector2.ZERO
	else:
		var next_point = nav.get_next_path_position()
		velocity = (next_point - global_position).normalized() * movement_speed
		if velocity.x < 0:
			sprite_2d.scale.x = -1
		elif velocity.x > 0:
			sprite_2d.scale.x = 1
	move_and_slide()
