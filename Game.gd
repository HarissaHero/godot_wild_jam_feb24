extends Node2D

var actualTimeCycle = ValueObjects.TimeCycle.DAY

@export var ENEMY_POPUP_RANGE = {"min" = 100, "max" = 300}

@onready var dayNightCycleTimer : Timer = $DayNightCycleTimer
@onready var dayNightCycleIndicatorLabel: Label = $Player/Camera2D/HUD/DayNightCycleIndicator
@onready var enemyPopupTimer: Timer = $EnemyPopupTimer
@onready var player: Node2D = $Player
@onready var environment: Node2D = $Environment

var Enemy = preload("res://enemy.tscn")

func _ready():
  dayNightCycleTimer.start()
  enemyPopupTimer.start()
  update_day_night_indicator()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  pass


func _on_day_night_cycle_timer_timeout():
  actualTimeCycle = ((actualTimeCycle + 1) % 2) as ValueObjects.TimeCycle
  update_day_night_indicator()


func update_day_night_indicator(): 
  dayNightCycleIndicatorLabel.text = "Day" if actualTimeCycle == ValueObjects.TimeCycle.DAY else "Night"


func create_enemy():
  var enemyInstance = Enemy.instantiate()
  enemyInstance.position = player.position \
    + (Vector2(\
      # x,y E [-500, -100] U [100, 500]
      randf_range(ENEMY_POPUP_RANGE.min, ENEMY_POPUP_RANGE.max) * pow(-1 , randi_range(1, 2)), \
      randf_range(ENEMY_POPUP_RANGE.min, ENEMY_POPUP_RANGE.max)) * pow(-1 , randi_range(1, 2)))

  environment.add_child(enemyInstance)


func _on_enemy_popup_timer_timeout():
  create_enemy()	

