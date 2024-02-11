extends CharacterBody2D

signal playerDeadSignal

@export var invincibilityDelay = 0.5
@export var maxEnergy = 100 

@onready var energyConsumptionTimer = $EnergyConsumptionTimer
@onready var energyHUDBar: ProgressBar = $Camera2D/HUD/ProgressBar
@onready var gameOverLabel: Label = $Camera2D/HUD/GameOver
@onready var scoreLabel: Label = $Camera2D/HUD/Score
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var comboBonusTimer: Timer = $ComboBonusTimer

var SPEED = 300.0

var energy: int = maxEnergy  

var invincibility = invincibilityDelay 

var combo = 1 
var score = 0

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
    energyConsumptionTimer.stop()
    comboBonusTimer.stop()

  if invincibility > 0:
    invincibility -= delta


func _on_energy_consumption_timer_timeout():
  energy -= 1
  score += 1
  update_score_label()


func _on_enemy_detector_body_entered(body:Node2D):
  if body.enemyStatus == ValueObjects.EnemyStatus.WEAK:
    body.queue_free()
    if combo > 1:
      SPEED = 600 
    combo += 1
    energy += 1 
    if energy > 100:
      energy = 100
    score += combo
    comboBonusTimer.start(-1)
    update_score_label()
  elif body.enemyStatus == ValueObjects.EnemyStatus.STRONG:
    energy -= 1
    reset_combo_speed()
    invincibility = invincibilityDelay 


func _on_combo_bonus_timer_timeout():
  reset_combo_speed()


func reset_combo_speed():
  combo = 1 
  SPEED = 300


func update_score_label():
  scoreLabel.text = "Score: {score}".format({"score": score})
