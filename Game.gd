extends Node2D

var actualTimeCycle = ValueObjects.TimeCycle.DAY

@onready var dayNightCycleTimer : Timer = $DayNightCycleTimer
@onready var dayNightCycleIndicatorLabel: Label = $Player/Camera2D/HUD/DayNightCycleIndicator

func _ready():
  dayNightCycleTimer.start()
  update_day_night_indicator()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  pass


func _on_day_night_cycle_timer_timeout():
  actualTimeCycle = ((actualTimeCycle + 1) % 2) as ValueObjects.TimeCycle
  update_day_night_indicator()


func update_day_night_indicator(): 
  dayNightCycleIndicatorLabel.text = "Day" if actualTimeCycle == ValueObjects.TimeCycle.DAY else "Night"
