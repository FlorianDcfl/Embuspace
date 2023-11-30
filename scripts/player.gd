extends Area2D

const turnspeed = 180

const movespeed = 500
const dashspeed = 7500
const acc = 0.06
const dec = 0.01
const freiner = 0.03
const dash = 1

var stop = false

var motion = Vector2(0,0)

var life = 2

var can_dash = true
var in_dash = false
var is_vulnerable = true

signal shoot(bullet, direction, location)
onready var Bullet = preload("res://scenes/bullet.tscn")


func _ready():
	pass
	

	
func on_timeout_complete():
	can_dash = true
	

func _process(delta):
	if in_dash == false :
		self.rotate(get_angle_to(get_global_mouse_position()))
	
	var movedir = Vector2(1,0).rotated(rotation)
	
	if Input.is_action_pressed("freiner") or stop == true:
		motion = motion.linear_interpolate(Vector2(0,0), freiner)
		$reacteur.lifetime = 0.06
	else:
		motion = motion.linear_interpolate(movedir, acc)
		$reacteur.lifetime = 0.4
	
	if Input.is_action_just_pressed("esquiver") && can_dash:
		$sound_dash.play()
		motion = motion.linear_interpolate(movedir, dash)
		position += motion * dashspeed * delta
		can_dash = false
		$TimerDashCooldown.start()
		is_vulnerable = false
		in_dash = true
		$reacteur.emitting = false
		$dashParticle.emitting = true
		$dashParticle2.emitting = true
		$ship.animation = "dash"
		$TimerDashInlvu.start(0.35)
		

	else:
		position += motion * movespeed * delta

	if Input.is_action_just_pressed("shoot"):
		$sound_shoot.play()
		emit_signal("shoot", Bullet, rotation, position)


func damage():
	if is_vulnerable == true:
		if life == 2 :
			$reacteur.modulate = Color.orange
		if life == 1 :
			$reacteur.modulate = Color.red
			$ship.playing = true
		if life == 0:
			stop = true
			$sound_death.play()
			$TimerDead.start()
		is_vulnerable = false
		$sound_damage.play()
		life -= 1
		$ship.frame = 1
		$TimerDamageInlvu.start(0.25)


func _on_Area2D_area_entered(area):
	if area.is_in_group("Ennemis"):
		damage()
		if area.is_in_group("Missile"):
			area.stop_timer_destruction()
			area.explode()
		else:
			area.explode()


func death():
		#animation death
		stop = true
		$CollisionPolygon2D.queue_free()
		$sound_death.play()
		$TimerDead.start()


func _on_Area2D_mouse_entered():
	stop = true


func _on_Area2D_mouse_exited():
	stop = false


func _on_TimerDead_timeout():
# warning-ignore:return_value_discarded
	get_tree().change_scene("scenes/gameover.tscn")


func _on_TimerInlvu_timeout():
	in_dash = false


func _on_TimerDashCooldown_timeout():
	can_dash = true


func _on_TimerDashInlvu_timeout():
	in_dash = false
	is_vulnerable = true
	$reacteur.emitting = true
	$ship.animation = "normal"


func _on_TimerDamageInlvu_timeout():
	is_vulnerable = true
	if life > 0 :
		$ship.frame = 0
