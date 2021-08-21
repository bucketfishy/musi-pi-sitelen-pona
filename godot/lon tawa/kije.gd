extends "res://lon tawa/tawa.gd"


#establish scene name for saving
export var scene_id = "kije"
signal climb

#physics modes with numbers
func _ready():
	raycasts = {
		"floor": [$floor1, $floor2, $floor3],
		"left": [$climbl1, $climbl2, $climbl3],
		"right": [$climbr1, $climbr2, $climbr3],
	}
	connect("climb", get_parent(), "kije_climb")

func get_input(delta):
		
	#settle these variables first
	var onfloor = raycast("floor")
	var wall_l = raycast("left") && Input.is_action_pressed("left")
	var wall_r = raycast("right") && Input.is_action_pressed("right")
	wall = wall_l || wall_r
	
	
	
	#direction of player
	var dir = 0
	if Input.is_action_pressed("right"):
		dir += 1
	if Input.is_action_pressed("left"):
		dir -= 1
	
	#sideways speed, and/or friction
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration * delta * 70)
	else:
		velocity.x = lerp(velocity.x, 0, friction * delta * 70)

	#apply gravity when finished jumping
	if Input.is_action_just_released("jump"):	
		if velocity.y < 0:
			velocity.y += jgravity
		jumping = false
			
	#normal jumping
	
	
	if Input.is_action_pressed("jump"):
		if wall:
			velocity.y = -climbspeed
		if raycast_climb("right") || raycast_climb("left"):
			emit_signal("climb")
			queue_free()
			
		
	#left + right movement
	if Input.is_action_pressed("right"):
		$Sprite.set_flip_h(false)

	elif Input.is_action_pressed("left"):
		$Sprite.set_flip_h(true)
	
	#animation
	if jumping:
		anim.travel("idle")
	elif Input.is_action_pressed("right") || Input.is_action_pressed("left"):
		anim.travel("walk")
	else:
		anim.travel("idle")

	
func _physics_process(delta):
	if focused:
		get_input(delta)
	if wall:
		velocity.y = clamp(velocity.y + wgravity * delta, -1500, 200)
	else:
		velocity.y = clamp(velocity.y + gravity * delta, -1500, 1500)
	var snap = Vector2.DOWN if !jumping else Vector2.ZERO
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP )
	
	
func raycast_climb(area):
	for i in raycasts[area]:
		if i.is_colliding():
			if i.get_collider().is_in_group("soweli"):
				return true
	return false
	