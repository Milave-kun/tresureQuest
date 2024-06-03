extends Area2D

var level = 1
var hp = 1
var damage = 5
var speed = 220

var knockback_amount = 100
var pearl_size = 0.5

var target = Vector2.ZERO
var angle = Vector2.ZERO

signal remove_from_array(object)

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	angle = global_position.direction_to(target)
	match level:
		1:
			hp = 1
			speed = 220
			damage = 5 
			knockback_amount = 100
			pearl_size =  0.5 * (1.0 + player.attack_size)
		2:
			hp = 2
			speed = 220
			damage = 8
			knockback_amount = 100
			pearl_size = 0.5 * (1.0 + player.attack_size)
		3:
			hp = 2
			speed = 220
			damage = 8
			knockback_amount = 100
			pearl_size = 0.5 * (1.0 + player.attack_size)
	
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1)*pearl_size,1).set_trans(Tween.TRANS_QUINT).set_ease(tween.EASE_OUT)
	tween.play()

func _physics_process(delta):
	position += angle * speed * delta
	
func enemy_hit(_charge):
	pass


func _on_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()
