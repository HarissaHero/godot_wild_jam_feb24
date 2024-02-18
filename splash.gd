extends Node2D

@onready var logo: CanvasItem = $CanvasLayer/Control/LogoOutlined
@onready var timer: Timer = $Timer

var tween: Tween

var state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
  create_run_fade_in_logo_tween()


func _on_timer_timeout():
  state += 1
  if state == 3: 
    tween.kill()
    create_run_fade_out_logo_tween()
  if state == 4:
    get_tree().change_scene_to_file("res://tutorial.tscn") 


func create_run_fade_in_logo_tween():
  tween = get_tree().create_tween()
  tween.tween_property($CanvasLayer/Control/LogoOutlined, "modulate",  Color(1,1,1,1), 1.)
  tween.play()


func create_run_fade_out_logo_tween():
  tween = get_tree().create_tween()
  tween.tween_property($CanvasLayer/Control/LogoOutlined, "modulate",  Color(1,1,1,0), 1.)
  tween.play()


