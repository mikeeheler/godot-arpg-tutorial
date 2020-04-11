extends KinematicBody2D

const FRICTION = 200
const KNOCKBACK_AMOUNT = 120


var knockback = Vector2.ZERO


func _physics_process(delta):
    knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
    knockback = move_and_slide(knockback)


func _on_Hurtbox_area_entered(area):
    var knockback_vector = (global_position - area.get_parent().global_position).normalized()
    knockback = knockback_vector * KNOCKBACK_AMOUNT
