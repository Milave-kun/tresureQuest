extends Node2D

@onready var SlimeTimer = get_node("%SlimeTimer")
@onready var KoboldTimer = get_node("%KoboldTimer")
@onready var CyclopsTimer = get_node("%CyclopsTimer")
@onready var JuggernautTimer = get_node("%JuggernautTimer")

func spawn_mob_slime():
	var new_mob =  preload("res://scene/slime.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position =   %PathFollow2D.global_position
	add_child(new_mob)
	
func spawn_mob_kobold():
	var new_mob =  preload("res://scene/Kobold.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position =   %PathFollow2D.global_position
	add_child(new_mob)

func spawn_mob_cyclops():
	var new_mob =  preload("res://scene/Cyclops.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position =   %PathFollow2D.global_position
	add_child(new_mob)

func spawn_mob_juggernaut():
	var new_mob =  preload("res://scene/Juggernaut.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position =   %PathFollow2D.global_position
	add_child(new_mob)

func spawn_mob_boss():
	var new_mob =  preload("res://scene/Boss.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position =   %PathFollow2D.global_position
	add_child(new_mob)

func _on_slime_timer_timeout():
	spawn_mob_slime()

func _on_boss_timer_timeout():
	spawn_mob_boss()

func _on_kobold_timer_timeout():
	spawn_mob_kobold()

func _on_cyclops_timer_timeout():
	spawn_mob_cyclops()

func _on_juggernaut_timer_timeout():
	spawn_mob_juggernaut()

func _on_wave_1_timeout():
	spawn_mob_slime()
	spawn_mob_slime()
	spawn_mob_slime()
	spawn_mob_slime()
	spawn_mob_slime()
	spawn_mob_slime()
	spawn_mob_slime()
	spawn_mob_slime()
	spawn_mob_slime()
	spawn_mob_slime()

func _on_wave_2_timeout():
	spawn_mob_kobold()
	spawn_mob_kobold()
	spawn_mob_kobold()
	spawn_mob_kobold()
	spawn_mob_kobold()
	spawn_mob_kobold()
	spawn_mob_kobold()
	spawn_mob_kobold()
	spawn_mob_kobold()
	spawn_mob_kobold()


func _on_wave_3_timeout():
	spawn_mob_cyclops()
	spawn_mob_cyclops()
	spawn_mob_cyclops()
	spawn_mob_cyclops()
	spawn_mob_cyclops()
	spawn_mob_cyclops()
	spawn_mob_cyclops()
	spawn_mob_cyclops()
	spawn_mob_cyclops()

func _on_turning_point_1_timeout():
	SlimeTimer.stop()
	KoboldTimer.start()
	
func _on_turning_point_2_timeout():
	KoboldTimer.stop()
	CyclopsTimer.start()


func _on_turning_point_3_timeout():
	CyclopsTimer.stop()
	JuggernautTimer.start()



