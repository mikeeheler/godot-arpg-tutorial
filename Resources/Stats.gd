extends Node

signal health_changed(value)
signal max_health_changed(value)
signal no_health

export(int) var max_health = 1 setget set_max_health

var health = 1 setget set_health


func _ready():
    self.health = max_health

func set_health(value):
    if health == value:
        return

    health = min(max_health, value)
    emit_signal("health_changed", value)
    if health <= 0:
        emit_signal("no_health")


func set_max_health(value):
    if max_health == value:
        return

    max_health = max(1, max(health, value))
    self.health = min(max_health, health)
    emit_signal("max_health_changed", max_health)
