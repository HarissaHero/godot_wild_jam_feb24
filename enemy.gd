extends CharacterBody2D
class_name Enemy

@onready var sprite = $AnimatedSprite2D

@export var STRONG_SPEED = 150.0
@export var WEAK_SPEED = 100.0

var enemyType: ValueObjects.EnemyType
var enemyStatus: ValueObjects.EnemyStatus

var gameInstance: Node2D
var colorShader: ShaderMaterial

var playerAlive = true

# Called when the node enters the scene tree for the first time.
func _ready():
  enemyType = randi_range(0,1) as ValueObjects.EnemyType
  gameInstance = get_node("/root/proto") 

  var shader = load("res://enemy.gdshader")
  colorShader = ShaderMaterial.new()
  colorShader.shader = shader
  var shaderColorParam = Vector3(1., .7, .7) if enemyType == ValueObjects.EnemyType.LIGHT else Vector3(0.7, 0.7, 1.)
  colorShader.set_shader_parameter("color", shaderColorParam)
  sprite.material = colorShader
  gameInstance.get_node("Player").playerDeadSignal.connect(_on_player_dead_signal)
  set_enemy_status()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
  if playerAlive: 
    if enemyStatus == ValueObjects.EnemyStatus.STRONG:
      move_toward_player()
    else: 
      run_away_from_player()

    move_and_slide()

  set_enemy_status()
  sprite.flip_h = true if velocity.x > 0 else false
  sprite.play("default")


func set_enemy_status(): 
  if (gameInstance.actualTimeCycle == ValueObjects.TimeCycle.NIGHT and enemyType == ValueObjects.EnemyType.DARK) \
    or (gameInstance.actualTimeCycle == ValueObjects.TimeCycle.DAY and enemyType == ValueObjects.EnemyType.LIGHT):
    enemyStatus = ValueObjects.EnemyStatus.STRONG 
    sprite.scale = Vector2(.5, .5)
  else: 
    enemyStatus = ValueObjects.EnemyStatus.WEAK 
    sprite.scale = Vector2(.3, .3)


func move_toward_player(): 
  var player = gameInstance.get_node("Player")

  var direction = position.direction_to(player.position)
  if direction:
    velocity.x = direction.x * STRONG_SPEED
    velocity.y = direction.y * STRONG_SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, STRONG_SPEED)
    velocity.y = move_toward(velocity.y, 0, STRONG_SPEED)


func run_away_from_player(): 
  var player = gameInstance.get_node("Player")

  var direction = position.direction_to(player.position)
  if direction:
    velocity.x = -direction.x * WEAK_SPEED
    velocity.y = -direction.y * WEAK_SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, WEAK_SPEED)
    velocity.y = move_toward(velocity.y, 0, WEAK_SPEED)


func _on_player_dead_signal():
  playerAlive = false
