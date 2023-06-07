extends KinematicBody2D

var init_vel = Vector2(500 , 0)
const gravity = 1500
const velX = 500 
var jump = false
var jump_release = false
var is_on_floor = false
var controled_jump = false

onready var mask = collision_mask
onready var layer = collision_layer

enum {IDLE , RUNNIG , FLYING , DEAD , VICTORY }

var status = IDLE

func _ready():
	add_to_group("player")
	$sprite.play("idle")
	set_process(true )
	pass


func _physics_process(delta):
	if status == RUNNIG:
		running(delta)
	elif status == FLYING:
		flaying(delta)	
	elif status == DEAD:
		dead(delta)
	
	if status != DEAD:
		if position.y > ProjectSettings.get_setting("display/window/size/height"):
			killed()
		
		
	jump = false
	jump_release = false

func running(delta):
	init_vel.y += gravity * delta
	init_vel.x = velX
	init_vel = move_and_slide(init_vel, Vector2(0 , -1))
	
	if is_on_floor(): # tocou no chao?
	   if not is_on_floor:
		   $anim_landed.play("boing")
		   $dust/anim.play("dust")
	   $sprite.play("walk")
	   if jump:
		   jump(1000 , true)
		   $jump.play()
	else:
		$sprite.play("jump")
		if jump_release and init_vel.y < 0 and controled_jump:
			init_vel.y *= .3
	
	is_on_floor = is_on_floor()


func flaying(delta):
	init_vel.y += gravity * delta
	init_vel.x = velX
	init_vel = move_and_slide(init_vel, Vector2(0 , -1))
	if jump:
		$wings/flap_audio.play()
		$wings/anim.play("flap")
		jump(450, false)

	if is_on_floor():
		get_tree().call_group("power_up_bar" , "stop")
		powerup_finished()
		
		

func dead(delta):
	$sprite.play("hurt")
	translate(init_vel * delta)
	init_vel.y += gravity * delta 
	if global_position.y > ProjectSettings.get_setting("display/window/size/height") + 100:
		get_tree().call_group("game", "player_died")

func _input(event):
	if event is InputEventScreenTouch or event.is_action("jump"):
		if event.pressed:
			jump = true
		else:
			jump_release = true
	
func jump(force, controled):
	init_vel.y = -force
	controled_jump = controled


func killed():
	if status != DEAD:
	   status = DEAD
	   collision_mask = 0 
	   collision_layer = 0
	   init_vel = Vector2(0 , -1000)
	   $dead.play()
	   get_tree().call_group("power_up_bar" , "stop")
	   get_tree().call_group("game" , "player_dying")


func flay():
	$sprite.play("jump")
	status = FLYING
	$wings.visible = true
	
func victory():
	$sprite.play("victory")
	status = VICTORY
	get_tree().call_group("game", "player_victory")


func powerup_finished():
	if status != DEAD:
		status = RUNNIG
		$wings.hide() 

func start():
	status = RUNNIG
