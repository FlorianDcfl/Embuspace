extends Area2D

#variables mouvement
var motion = Vector2(0,0)
onready var vaisseau = get_tree().get_root().get_node("Node2D/vaisseau")

var velocity = Vector2(0,0)

var is_activate = false
var is_homing = false

var speed = 400

func _ready():
	pass


func _physics_process(delta):
	var movedir = Vector2(1,0).rotated(rotation)
	
	if is_activate == false:
		motion = motion.linear_interpolate(movedir, 0.1)
	elif is_activate == true and is_homing == false:
		motion = motion.linear_interpolate(Vector2(0,0), 0.03)
	else:
		self.rotate(get_angle_to(vaisseau.position)*delta * 3)
		motion = motion.linear_interpolate(movedir,0.1)
	position += motion * speed * delta


func explode():
	$AnimatedSprite.visible = false
	$reacteur_ennemi.emitting = false
	$reacteur_ennemi.visible = false
	$explosion.emitting = true
	$CollisionShape2D.queue_free()
	$timer_explosion.start()


func _on_timer_explosion_timeout():
	self.queue_free()


func _on_TimerActivate_timeout():
	is_activate = true
	$TimerHoming.start()
	$AnimatedSprite.frame = 1


func _on_TimerHoming_timeout():
	is_homing = true
	speed = 500
	$AnimatedSprite.play()
	$reacteur_ennemi.emitting = true
	$TimerDestruction.start()


func _on_TimerDestruction_timeout():
	explode()


func stop_timer_destruction():
	$TimerDestruction.stop()
