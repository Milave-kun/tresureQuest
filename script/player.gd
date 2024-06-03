extends CharacterBody2D

signal health_depleted

var health  = 80
var maxhealth = 80
var speed = 35
var player_state
var time =  0


var arrow = preload("res://scene/pearl.tscn")
var fireball = preload("res://scene/arrow.tscn")

#Timer
@onready var SlimeTimer =  get_node("%SlimeTimer")
@onready var KoboldTimer =  get_node("%KoboldTimer")

#Attack
@onready var ThrowTimer = get_node("%ThrowTimer")
@onready var ThrowAttackTimer = get_node("%ThrowAttackTimer")
@onready var FireballTimer = get_node("%FireballTimer")
@onready var FireballAtackTimer = get_node("%FireballAttackTimer")

#ARROW
var arrow_ammo = 0
var arrow_baseammo = 1
var arrow_attackspeed = 1.5
var arrow_level = 1

#Fireball
var fireball_ammo = 0
var fireball_baseammo = 1
var fireball_attackspeed = 1.5
var fireball_level = 0

#enemy
var enemy_close = []

#EXP
var experience = 0
var experience_level = 1
var collected_experience = 0

#UPGRADES
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var move_speed = 0 
var attack_size = 0
var additional_attacks = 0

@onready var expbar = get_node("%ExpBar")
@onready var lblLevel = get_node("%lbl_level")
@onready var healthbar = get_node("%ProgressBar")
@onready var levelPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var ItemOptions = preload("res://scene/item_options.tscn")
@onready var sndLevelUp = get_node("%snd_levelup")
@onready var lblTimer = get_node("%lbl_Timer")
@onready var CollectedWeapons = get_node("%CollectedWeapons")
@onready var ColleectedUpgrades = get_node("%CollectedUpgrades")
@onready var ItemContainer = preload("res://scene/item_container.tscn")

@onready var deathPanel = get_node("%DeathPanel")
@onready var lblResult = get_node("%lbl_Result")
@onready var sndVictory = get_node("%snd_victory")
@onready var sndLose = get_node("%snd_lose")

signal playerdeath

func _ready():
	attack()
	set_expbar(experience, calculate_experiencecap())
	_on_hurt_box_hurt(0,0,0)

func _physics_process(delta):
	var direction = Input.get_vector("left","right","up","down")
	
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
		
		velocity = direction * speed
		move_and_slide()
			
	play_anim(direction)

func play_anim(dir):
	if player_state == "idle":
		$AnimatedSprite2D.play("idle")
	if player_state == "walking":
		if dir.y == -1:
			$AnimatedSprite2D.play("n-walk")
		if dir.x == 1:
			$AnimatedSprite2D.play("e-walk")
		if dir.y == 1:
			$AnimatedSprite2D.play("s-walk")
		if dir.x == -1:
			$AnimatedSprite2D.play("w-walk")
			
		if dir.x > 0.5 and dir.y < -0.5:
			$AnimatedSprite2D.play("ne-walk")
		if dir.x > 0.5 and dir.y > 0.5:
			$AnimatedSprite2D.play("se-walk")
		if dir.x < -0.5 and dir.y > 0.5:
			$AnimatedSprite2D.play("sw-walk")
		if dir.x < -0.5 and dir.y < -0.5:
			$AnimatedSprite2D.play("nw-walk")
		
func player():
	pass
	
func attack():
	if arrow_level > 0:
		ThrowTimer.wait_time = arrow_attackspeed
		if ThrowTimer.is_stopped():
			ThrowTimer.start()
	if fireball_level > 0:
		FireballTimer.wait_time = fireball_attackspeed
		if FireballTimer.is_stopped():
			FireballTimer.start()


func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)

func calculate_experience(gem_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required: #level up
		collected_experience -= exp_required - experience
		experience_level += 1
		experience = 0
		exp_required = calculate_experiencecap()
		levelup()
	else:
		experience += collected_experience
		collected_experience = 0
	
	set_expbar(experience, exp_required)
	
func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level * 5
	elif experience_level < 40:
		exp_cap + 95 * (experience_level-19) * 8
	else:
		exp_cap = 255 + (experience_level-39) * 12
	return exp_cap

func set_expbar(set_value = 1, set_max_value = 100):
	expbar.value = set_value
	expbar.max_value = set_max_value
	
func _on_hurt_box_hurt(damage, _angle, _knockback):
	health -= clamp(damage-armor, 1.0, 999.0)
	healthbar.max_value = maxhealth
	healthbar.value = health
	if health <= 0:
		death()

func _on_arrow_timer_timeout():
	arrow_ammo += arrow_baseammo + additional_attacks
	%ThrowAttackTimer.start()


func _on_arrow_attack_timer_timeout():
	if arrow_ammo > 0:
		var arrow_attack = arrow.instantiate()
		arrow_attack.position = position
		arrow_attack.target = get_random_target()
		arrow_attack.level = arrow_level
		add_child(arrow_attack)
		arrow_ammo -= 1
		if arrow_ammo > 0:
			%ThrowAttackTimer.start()
		else:
			%ThrowAttackTimer.stop()

func _on_fireball_timer_timeout():
	fireball_ammo += fireball_baseammo + additional_attacks
	FireballAtackTimer.start()

func _on_fireball_attack_timer_timeout():
	if fireball_ammo > 0:
		var fireball_attack = fireball.instantiate()
		fireball_attack.position = position
		fireball_attack.target = get_random_target()
		fireball_attack.level = fireball_level
		add_child(fireball_attack)
		fireball_ammo -= 1
		if fireball_ammo > 0:
			FireballAtackTimer.start()
		else:
			FireballAtackTimer.stop()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func levelup():
	sndLevelUp.play()
	lblLevel.text = str("Level: ",experience_level)
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel,"position", Vector2(400,175),0.2).set_trans(Tween.TRANS_QUINT).set_ease(tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	var options = 0
	var optionmax = 3
	while options < optionmax:
		var option_choice = ItemOptions.instantiate()
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true

func upgrade_character(upgrade):
	match upgrade:
		"Bullet1":
			arrow_level = 1
			arrow_baseammo += 1
		"Bullet2":
			arrow_level = 2
			arrow_baseammo += 1
		"Bullet3":
			arrow_level = 3
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			speed += 7.0
		"tome1","tome2","tome3","tome4":
			attack_size += 0.2
		"ring1","ring2":
			additional_attacks += 1
		"food":
			_on_hurt_box_hurt(0,0,0)
			health += 20
			health = clamp(health,0,maxhealth)
	adjust_gui_collection(upgrade)
	attack()
	var options_children = upgradeOptions.get_children()
	for i in options_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	levelPanel.position = Vector2(1400,175)
	get_tree().paused = false
	calculate_experience(0)

func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades:
			pass
		elif i in upgrade_options:
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item":
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0:
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
				if to_add:
					dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomItem = dblist.pick_random()
		upgrade_options.append(randomItem)
		return randomItem
	else:
		return null


func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)

func change_time(argtime = 0):
	time = argtime
	var get_m = int(time/60.0)
	var get_s = time % 60
	if get_m < 10:
		get_m = str(0,get_m)
	if get_s < 10:
		get_s = str(0,get_s)
	lblTimer.text = str(get_m,":",get_s)

func adjust_gui_collection(upgrade):
	var get_upgraded_displayname = UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_displaynames = []
		for i in collected_upgrades:
			get_collected_displaynames.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displayname in get_collected_displaynames:
			var new_item = ItemContainer.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					CollectedWeapons.add_child(new_item)
				"upgrade":
					ColleectedUpgrades.add_child(new_item)

func death():
	deathPanel.visible = true
	emit_signal("playerdeath")
	get_tree().paused = true
	var tween = deathPanel.create_tween()
	tween.tween_property(deathPanel,"position",Vector2(400,175),3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	if time >= 300:
		lblResult.text = "You Win"
		sndVictory.play()
	else:
		lblResult.text = "You Lose"
		sndLose.play()


func _on_btn_menu_click_end():
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://scene/menu.tscn")

