extends KinematicBody2D

const ACCELERATION = 500
const FRICTION = 500
const MAX_SPEED = 80

enum {
    MOVE,
    ROLL,
    ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
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
    
func attack_state(_delta):
    velocity = Vector2.ZERO
    animationState.travel("Attack")
    
func attack_animation_finished():
    state = MOVE

func move_state(delta):
    var input_vector = Vector2.ZERO
    input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
    
    if input_vector.length() > 0.1:
        animationTree.set("parameters/Idle/blend_position", input_vector)
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
