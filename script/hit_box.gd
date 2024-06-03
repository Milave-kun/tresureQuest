extends Area2D

@export var damage = 3

@onready var collision = $CollisionShape2D
@onready var disabledTimer = $DisabledHitBoxTimer

func tempdisable():
	collision.call_deferred("set","disabled", true)
	disabledTimer.start()

func _on_disabled_hit_box_timer_timeout():
		collision.call_deferred("set","disabled", false)
