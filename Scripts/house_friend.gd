extends CharacterBody2D

@export var player: CharacterBody2D = null
@export var SPEED: float = 250.0
@export var distance_to_track: float = 70.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var perception: Area2D = $Perception
@onready var ray: RayCast2D = $RayCast2D

var player_in_range: bool = false

@export var navigation_agent: NavigationAgent2D = null
@onready var entrance: Marker2D = $"../Static/Entrance"
@onready var bathroom: Marker2D = $"../Static/Bathroom"
@onready var bedroom: Marker2D = $"../Static/Bedroom"
@onready var kitchen: Marker2D = $"../Static/Kitchen"


var targets = []

func _ready():
	perception.body_entered.connect(_on_body_entered)
	perception.body_exited.connect(_on_body_exited)
	
	targets.append(entrance)
	targets.append(bathroom)
	targets.append(bedroom)
	targets.append(kitchen)
	
	navigation_agent.velocity_computed.connect(Callable(self._on_velocity_computed))
	set_movement_target(targets[0].position)


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
		if navigation_agent.is_navigation_finished():
			return
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		var current_agent_position: Vector2 = global_position
		var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * SPEED
		if navigation_agent.avoidance_enabled:
			navigation_agent.set_velocity(new_velocity)
		else:
			self._on_velocity_computed(new_velocity)
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
	

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()
	
func set_movement_target(movement_target: Vector2):
	navigation_agent.set_target_position(movement_target)



func _on_change_target_timeout() -> void:
	var target_index = randi_range(0, 3)
	set_movement_target(targets[target_index].position)
