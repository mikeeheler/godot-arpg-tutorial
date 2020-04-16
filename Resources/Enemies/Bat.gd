extends KinematicBody2D

export var acceleration = 300
export var max_speed = 50
export var friction = 200

const MOVE_FRICTION = 200

const EnemyDeathEffect = preload("res://Resources/Effects/EnemyDeathEffect.tscn")

enum {
    IDLE,
    WANDER,
    CHASE,
}

var knockback = Vector2.ZERO
var state = CHASE
var velocity = Vector2.ZERO

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone

func _physics_process(delta):
    knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
    knockback = move_and_slide(knockback)

    match state:
        IDLE:
            velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
            seek_player()

        WANDER:
            pass

        CHASE:
            var player = playerDetectionZone.player
            if player != null:
                var direction = (player.global_position - global_position).normalized()
                velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
                sprite.flip_h = velocity.x < 0
            else:
                state = IDLE

    velocity = move_and_slide(velocity)

func seek_player():
    if playerDetectionZone.can_see_player():
        state = CHASE

func _on_Hurtbox_area_entered(area):
    stats.health -= area.damage
    var knockback_vector = (global_position - area.get_parent().global_position).normalized()
    knockback = knockback_vector * 120

func _on_Stats_no_health():
    queue_free()
    var enemyDeathEffect = EnemyDeathEffect.instance()
    get_parent().add_child(enemyDeathEffect)
    enemyDeathEffect.global_position = global_position
