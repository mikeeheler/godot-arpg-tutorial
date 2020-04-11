extends KinematicBody2D

const FRICTION = 200
const KNOCKBACK_AMOUNT = 120

var knockback = Vector2.ZERO

onready var stats = $Stats


func _physics_process(delta):
    knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
    knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
    stats.health -= area.damage
    var knockback_vector = (global_position - area.get_parent().global_position).normalized()
    knockback = knockback_vector * KNOCKBACK_AMOUNT

func _on_Stats_no_health():
    queue_free()
