extends CharacterBody2D

const speed_length = 320.0
@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(delta):
	var speed_direction = Vector2()
	if Input.is_action_pressed("ui_up"):
		speed_direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		speed_direction.y += 1
	if Input.is_action_pressed("ui_left"):
		speed_direction.x -= 1
		sprite_2d.scale.x = -1
	if Input.is_action_pressed("ui_right"):
		speed_direction.x += 1
		sprite_2d.scale.x = 1
	velocity = speed_direction.normalized() * speed_length
	move_and_slide()
