extends Area2D


signal hit


export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide() # Wait to show the player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Set velocity to zero on each delta (start from scratch)
	var velocity = Vector2.ZERO # The player's movement vector.

	# Check for inputs and append them to the velocity
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	# If the inputs are hit then we normalize the vectory so they don't go
	# faster diagonally		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	# Clamp the Player (make sure they do not go off screen)
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	# Check the direction to show the right animation
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = velocity.y > 0
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


# Happens when an enemy hits the player
func _on_Player_body_entered(body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	print("hit signal called")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)


# Called when the start button is clicked
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
