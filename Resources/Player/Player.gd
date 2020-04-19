extends KinematicBody2D

enum {
    MOVE,
    ROLL,
    ATTACK
}

const ACCELERATION = 500
const FRICTION = 500
const MAX_SPEED = 80
const ROLL_SPEED = 120

var roll_vector = Vector2.DOWN
var state = MOVE
var stats = PlayerStats
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hurtbox = $Hurtbox


func _ready():
    stats.connect("no_health", self, "queue_free")
    animationTree.active = true


func _physics_process(delta):
    match state:
        MOVE:
            move_state(delta)
        ROLL:
            pass
        ATTACK:
            pass


func _process(delta):
    if state == ATTACK:
        attack_state(delta)
    elif state == ROLL:
        roll_state(delta)


func attack_animation_finished():
    state = MOVE


func attack_state(_delta):
    velocity = Vector2.ZERO
    animationState.travel("Attack")


func move_state(delta):
    var input_vector = Vector2.ZERO
    input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

    if input_vector.length() > 0.1:
        roll_vector = input_vector
        animationTree.set("parameters/Idle/blend_position", input_vector)
        animationTree.set("parameters/Roll/blend_position", input_vector)
        animationTree.set("parameters/Run/blend_position", input_vector)
        animationTree.set("parameters/Attack/blend_position", input_vector)
        animationState.travel("Run")
        velocity = velocity.move_toward(input_vector.normalized() * MAX_SPEED, ACCELERATION * delta)
    else:
        animationState.travel("Idle")
        velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

    velocity = move_and_slide(velocity)

    if Input.is_action_just_pressed("player_attack"):
        state = ATTACK

    if Input.is_action_just_pressed("player_roll"):
        state = ROLL


func roll_animation_finished():
    velocity = Vector2.ZERO
    state = MOVE


func roll_state(_delta):
    animationState.travel("Roll")
    velocity = move_and_slide(roll_vector * ROLL_SPEED)


func _on_Hurtbox_area_entered(area):
    stats.health -= 1
    hurtbox.start_invincibility(0.5)
    hurtbox.create_hit_effect()
