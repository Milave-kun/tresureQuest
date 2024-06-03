extends CharacterBody2D

@export var experience = 1
@export var health = 10
@export var move_speed = 40.0
@export var knockback_recovery = 3.5
@export var enemy_damage = 1
var knockback = Vector2.ZERO

var death_anim = preload("res://scene/explosion.tscn")

@onready var sprite = %AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var snd_hit = $snd_hit
@onready var Hitbox = $HitBox

signal remove_from_array(object)

var exp_gem = preload("res://scene/experience.tscn")

func _ready():
	Hitbox.damage = enemy_damage
	play_walk()

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * move_speed
	velocity += knockback
	move_and_slide() 

func death():
	emit_signal("remove_from_array", self)
	var enemy_death = death_anim.instantiate()
	enemy_death.scale = sprite.scale
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child",enemy_death)
	queue_free()

func _on_hurt_box_hurt(damage, angle, knockback_amount):
	health -= damage
	knockback = angle * knockback_amount
	if health <= 0:
		var new_gem = exp_gem.instantiate()
		new_gem.global_position = global_position
		new_gem.experience = experience
		loot_base.call_deferred("add_child", new_gem)
		death()
	else:
		snd_hit.play()

func play_walk():
	%AnimatedSprite2D.play("move")
	
func play_death():
	%AnimatedSprite2D.play("death")
