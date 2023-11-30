extends Node2D

#onready var enemy = get_tree().get_nodes_in_group("Ennemis")
onready var EnnemiVaisseau1 = preload("res://scenes/enemy1.tscn")
onready var EnnemiVaisseau2 = preload("res://scenes/enemy2.tscn")
onready var EnnemiVaisseau3 = preload("res://scenes/enemy3.tscn")

onready var score = get_node("/root/score")

onready var screensize = get_viewport_rect().size
var randx
var randy
var spawn_position
var spawn

var in_paused = false

var nbBoucle = 1
var timeSpawn = 7.5

func _ready():
# warning-ignore:return_value_discarded
	$vaisseau.connect("shoot", self,"on_shoot")
	score.scorePlayer = 0
	$score.text = "Score : " + str(score.scorePlayer)

# warning-ignore:unused_argument
func _process(delta):
	timer_start()
	score_actualisation()
	
func _input(event):
	if Input.is_action_just_pressed("restart"):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		$Pause.show()


func _on_TimerStart_timeout():
	get_tree().paused = false
	enemy_spawn(1)
	enemy_spawn(1)
	$TimerSpawn.start(7.5)


func _on_TimerSpawn_timeout():
	if nbBoucle % 2 == 0:
		enemy_spawn(2)
	if nbBoucle % 3 == 0:
		enemy_spawn(3)
	if nbBoucle % 5== 0:
		enemy_spawn(1)
	if score.scorePlayer > 2000 :
		timeSpawn = 5
		if nbBoucle % 4 == 0:
			enemy_spawn(2)
		if nbBoucle % 7 == 0:
			enemy_spawn(3)
		if nbBoucle % 10 == 0:
			enemy_spawn(1)
	nbBoucle += 1
	$TimerSpawn.start(timeSpawn)


func enemy_spawn(type):
	randomize()
	
	if type == 1:
		if $vaisseau.position.y < screensize.y/2 :
			randx = screensize.x - rand_range(0, screensize.x)
			spawn_position = Vector2(randx, screensize.y)
			spawn = EnnemiVaisseau1.instance()
		else:
			randx = screensize.x - rand_range(0, screensize.x)
			spawn_position = Vector2(randx, 0)
			spawn = EnnemiVaisseau1.instance()
			
	if type == 2 :
		if $vaisseau.position.x < screensize.x/2 :
			randy = screensize.y - rand_range(0, screensize.y)
			spawn_position = Vector2(screensize.x, randy)
			spawn = EnnemiVaisseau2.instance()
		else:
			randy = screensize.y - rand_range(0, screensize.y)
			spawn_position = Vector2(0, randy)
			spawn = EnnemiVaisseau2.instance()

	if type == 3:
		if $vaisseau.position.y < screensize.y/2 :
			randx = screensize.x - rand_range(0, screensize.x)
			spawn_position = Vector2(randx, screensize.y)
			spawn = EnnemiVaisseau3.instance()
		else:
			randx = screensize.x - rand_range(0, screensize.x)
			spawn_position = Vector2(randx, 0)
			spawn = EnnemiVaisseau3.instance()
			
	add_child(spawn)
	spawn.position = spawn_position
	spawn.connect("shoot", self,"on_shoot")
	if type == 1 :
		spawn.connect("spawn", self, "enemy_spawn")
	spawn.look_at($vaisseau.position)


func on_shoot(Bullet, direction, location):
	var b = Bullet.instance()
	add_child(b)
	b.rotation = direction
	b.position = location


func score_actualisation():
	if score.scorePlayer < 10 :
		$score.text = "0000" + str(score.scorePlayer)
	elif score.scorePlayer < 100:
		$score.text = "000" + str(score.scorePlayer)
	elif score.scorePlayer < 1000:
		$score.text = "00" + str(score.scorePlayer)
	elif score.scorePlayer < 10000:
		$score.text = "0" + str(score.scorePlayer)
	else:
		$score.text = str(score.scorePlayer)

func timer_start():
	if $TimerStart.time_left <= 1 and $TimerStart.time_left > 0 :
		$start.text = "START !"
	elif $TimerStart.time_left == 0 :
		$start.text = ""
	else:
		$start.text = str(int($TimerStart.time_left))


func _on_btQuit_pressed():
	get_tree().change_scene("scenes/menu.tscn")
	get_tree().paused = false


func _on_btResume_pressed():
	get_tree().paused = false
	$Pause.hide()


func _on_btRetry_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false
	$Pause.hide()


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
