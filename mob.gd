extends RigidBody2D
@export var bullet_scene: PackedScene
var can_shoot := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()
	add_to_group("enemy")
	if can_shoot:
		shoot_with_delay()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func shoot_with_delay():
	await get_tree().create_timer(randf_range(0.5, 1.5)).timeout
	shoot_at_player()
	
func shoot_at_player():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	var bullet = bullet_scene.instantiate()
	bullet.position = position

	var direction = (player.position - position).normalized()
	
	# Si usas RigidBody2D para la bala:
	bullet.linear_velocity = direction * 400

	get_parent().add_child(bullet)
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
