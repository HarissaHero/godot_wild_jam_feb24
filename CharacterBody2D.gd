extends CharacterBody2D

signal playerDeadSignal

@onready var energyConsumptionTimer = $EnergyConsumptionTimer
@onready var energyHUDBar: ProgressBar = $Camera2D/HUD/ProgressBar
@onready var gameOverLabel: Label = $Camera2D/HUD/GameOver

const SPEED = 300.0

var energy: int = 100

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


func _process(_delta):
  energyHUDBar.set_value_no_signal(energy)
  if energy == 0:
    # play dead animation 
    playerDeadSignal.emit() 
    gameOverLabel.visible = true


func _on_energy_consumption_timer_timeout():
  energy -= 1
