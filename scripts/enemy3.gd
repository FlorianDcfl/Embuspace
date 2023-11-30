extends Area2D

#variables mouvement
var motion = Vector2(0,0)
onready var vaisseau = get_tree().get_root().get_node("Node2D/vaisseau")

var lastRotation

signal spawnLittleEnemy(enemy, direction, location)
onready var homingMissile = preload("res://scenes/homing_missile.tscn")

#variables shoot
signal shoot(bullet, direction, location)
onready var EnemyBullet = preload("res://scenes/enemy_bullet.tscn")

onready var score = get_node("/root/score")

var life = 1
var is_vulnerable = true

#variables timer shoot
var timer = null
var shoot_delay =2
var can_shoot = false


func _ready():
	look_at(vaisseau.position)
	lastRotation = rotation


func _physics_process(delta):
	#déplacement et tir ennemis
	self.rotate(get_angle_to(vaisseau.position)*delta * 0.5)
	var movedir = Vector2(1,0).rotated(rotation)
	motion = motion.linear_interpolate(movedir,0.1)
	position += motion * 50 * delta
	
	if int(rotation_degrees * 1e1) == int(lastRotation * 1e1):
		$reacteur/reacteur_ennemi2.emitting = true
		$reacteur/reacteur_ennemi3.emitting = true
	elif rotation_degrees > lastRotation:
		$reacteur/reacteur_ennemi3.emitting = false
	else:
		$reacteur/reacteur_ennemi2.emitting = false
	lastRotation = rotation_degrees


func on_timeout_complete():
	can_shoot = true


func damage():
	if life == 0:
		explode() 
	else:
#		$CollisionShape2D.set_deferred("disabled", true)
#		is_vulnerable = false
		self.add_to_group("Invinsible")
		$Sprite.playing = true
		$TimerInlvu.start()



func explode():
	$Sprite.visible = false
	$reacteur.visible = false
	$explosion.emitting = true
	$sound_death_ennemy.play()
	$CollisionShape2D.queue_free()
	$timer_explosion.start()


func _on_timer_explosion_timeout():
	score.scorePlayer += 500
	self.queue_free()


func _on_TimerBullet_timeout():
	emit_signal("shoot", EnemyBullet, rotation - 0.5, $canon2.global_position)
	emit_signal("shoot", EnemyBullet, rotation + 0.5, $canon3.global_position)


func _on_TimerMissile_timeout():
	emit_signal("shoot", homingMissile, rotation, $canon1.global_position)


func _on_TimerInlvu_timeout():
	self.remove_from_group("Invinsible")
	$Sprite.playing = false
	$Sprite.frame = 1
	$TimerMissile.stop()
	life -= 1
	$sound_death_ennemy.play()
