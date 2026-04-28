extends RigidBody2D
var bounces := 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("bullet")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if linear_velocity.length() > 0:
		rotation = linear_velocity.angle()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	# Si quieres que la bala desaparezca al impactar:
	bounces -= 1
	if bounces <= 0:
		queue_free()
	queue_free()
