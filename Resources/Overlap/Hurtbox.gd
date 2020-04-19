extends Area2D

signal invincibility_started
signal invincibility_ended

const HitEffect = preload("res://Resources/Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer


func create_hit_effect():
    var effect = HitEffect.instance()
    var main = get_tree().current_scene
    main.add_child(effect)
    effect.global_position = global_position


func start_invincibility(duration):
    set_invincible(true)
    timer.start(duration)


func set_invincible(value):
    if invincible == value:
        return

    invincible = value
    if value:
        emit_signal("invincibility_started")
    else:
        emit_signal("invincibility_ended")


func _on_Hurtbox_invincibility_ended():
    set_deferred("monitorable", true)


func _on_Hurtbox_invincibility_started():
    set_deferred("monitorable", false)


func _on_Timer_timeout():
    set_invincible(false)
