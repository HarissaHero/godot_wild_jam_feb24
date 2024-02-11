extends CharacterBody2D

signal playerDeadSignal

@export var invincibilityDelay = 0.5
@export var maxEnergy = 100 

@onready var energyConsumptionTimer = $EnergyConsumptionTimer
@onready var energyHUDBar: ProgressBar = $Camera2D/HUD/ProgressBar
@onready var gameOverLabel: Label = $Camera2D/HUD/GameOver
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0

var energy: int = maxEnergy  

var invincibility = invincibilityDelay 

func _ready():
  energyConsumptionTimer.start()

func _physics_process(_delta):
  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  if energy > 0:
    var directionX = Input.get_axis("ui_left", "ui_right")
    var directionY = Input.get_axis("ui_up", "ui_down")
    if directionX:
      velocity.x = directionX * SPEED
    else:
      velocity.x = move_toward(velocity.x, 0, SPEED)

    if directionY:
      velocity.y = directionY * SPEED
    else:
      velocity.y = move_toward(velocity.y, 0, SPEED)

    move_and_slide()
    animation.flip_h = true if velocity.x > 0 else false
    animation.play("idle")


func _process(delta):
  energyHUDBar.set_value_no_signal(energy)
  if energy == 0:
    # play dead animation 
    playerDeadSignal.emit() 
    gameOverLabel.visible = true

  if invincibility > 0:
    invincibility -= delta


func _on_energy_consumption_timer_timeout():
  energy -= 1


func _on_enemy_detector_body_entered(body:Node2D):
  if body.enemyStatus == ValueObjects.EnemyStatus.WEAK:
    body.queue_free()
    energy += 1
  elif body.enemyStatus == ValueObjects.EnemyStatus.STRONG:
    energy -= 1
    invincibility = invincibilityDelay 

