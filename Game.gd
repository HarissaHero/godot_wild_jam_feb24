extends Node2D

enum TimeCycle {
  DAY = 0,
  NIGHT = 1
}

var actualTimeCycle = TimeCycle.DAY

@onready var dayNightCycleTimer : Timer = $DayNightCycleTimer
@onready var dayNightCycleIndicatorLabel: Label = $HUD/DayNightCycleIndicator

# Called when the node enters the scene tree for the first time.
func _ready():
  dayNightCycleTimer.start()
  update_day_night_indicator()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func _on_day_night_cycle_timer_timeout():
  actualTimeCycle = ((actualTimeCycle + 1) % 2) as TimeCycle
  update_day_night_indicator()


func update_day_night_indicator(): 
  dayNightCycleIndicatorLabel.text = "Day" if actualTimeCycle == TimeCycle.DAY else "Night"
