extends CharacterBody2D
@onready var animas = $AnimatedSprite2Dth
@onready var nav_agent = $NavigationAgent2D

var current_action_id = 0
var arrived = false
var speed = 90
var target_position = Vector2(294, 42)
var returning = false
var moving = false
var break_started = false
var checking = false
var return_position = Vector2(170, 47)


func _ready():
	position = Vector2(170, 47)
	animas.play("idleteach")


func start_break():
	target_position = Vector2(170, 36)
	nav_agent.target_position = target_position
	returning = true
	moving = true

func _physics_process(delta):
	z_index = int(global_position.y + 15)
	if moving:
		var next_point = nav_agent.get_next_path_position()
		var direction = (next_point - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		update_animation(direction)
		if nav_agent.is_navigation_finished():
			moving = false
			velocity = Vector2.ZERO
			arrived = true
			animas.play("idleteach")
	else:
		velocity = Vector2.ZERO
		if animas.animation != "idleteach":
			animas.play("idleteach")

func update_animation(direction):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animas.play("walkrightteach")
		else:
			animas.play("walkleftteach")
	else:
		if direction.y > 0:
			animas.play("walkdownteach")
		else:
			animas.play("walkupteach")



func start_break_timer():
	visible = false
	global_position.x = 352
	await get_tree().create_timer(15).timeout
	visible = true
	global_position.x = 294
	target_position = Vector2(170, 36)
	returning = true
	moving = true
	
func check_place(pos):
	current_action_id += 1
	arrived = false
	target_position = pos
	nav_agent.target_position = pos
	moving = true
	return current_action_id

func go_back():
	target_position = return_position
	nav_agent.target_position = return_position
	arrived = false
	moving = true
