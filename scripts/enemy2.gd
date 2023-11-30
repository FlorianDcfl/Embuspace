extends Area2D

#variables mouvement
var motion = Vector2(0,0)
onready var vaisseau = get_tree().get_root().get_node("Node2D/vaisseau")



#variables shoot
signal shoot(bullet, direction, location)
onready var fastBullet = preload("res://scenes/enemy_fast_bullet.tscn")

onready var score = get_node("/root/score")

#variables timer shoot
var timer = null
var shoot_delay =2
var can_shoot = false


func _ready():
	look_at(vaisseau.position)
	
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(shoot_delay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	
	if can_shoot == false:
		timer.start()

func _physics_process(delta):
	#déplacement et tir ennemis
	self.rotate(get_angle_to(vaisseau.position)*delta * 3 )
	var movedir = Vector2(1,0).rotated(rotation)
	motion = motion.linear_interpolate(movedir,0.1)
	position += motion * 150 * delta
	
	if can_shoot == true:
		emit_signal("shoot", fastBullet, rotation, $canon1.global_position)
		emit_signal("shoot", fastBullet, rotation, $canon2.global_position)
		can_shoot = false
		timer.start()
		

func on_timeout_complete():
	can_shoot = true

func explode():
	$Sprite.visible = false
	$reacteur.visible = false
	$explosion.emitting = true
	$sound_death_ennemy.play()
	$CollisionShape2D.queue_free()
	timer.stop()
	$timer_explosion.start()


func _on_timer_explosion_timeout():
	score.scorePlayer += 100
	self.queue_free()