extends Node

@export var mob_scene: PackedScene
var score
var shoot_chance := 0.0   # Probabilidad actual (0 a 1)
var max_shoot_chance := 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Player.start($StartPosition.position)
	get_tree().call_group("bullet", "queue_free")
	$HUD.show_start_screen()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	$DeathSound.play()
	$HUD.show_game_over()
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("bullet", "queue_free")
	get_tree().call_group("enemy", "queue_free")
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_get_ready()
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("bullet", "queue_free")
	get_tree().call_group("enemy", "queue_free")
	$Music.play()


func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	if score >= 10:
		if randf() < shoot_chance:
			mob.can_shoot = true
		else:
			mob.can_shoot = false
	
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	update_shoot_chance()


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func update_shoot_chance():
	# Cada 10 puntos aumenta la probabilidad
	var level = int(score / 10)

	# Empieza en 10% (0.1) y sube de 5% en 5%
	shoot_chance = 0.1 + (level * 0.05)

	# Limitar a máximo 50%
	shoot_chance = min(shoot_chance, max_shoot_chance)
