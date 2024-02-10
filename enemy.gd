extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var label = $Label

const SPEED = 200.0

var enemyType: ValueObjects.EnemyType
var enemyStatus: ValueObjects.EnemyStatus

var gameInstance: Node2D
var colorShader: ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
  enemyType = randi_range(0,1) as ValueObjects.EnemyType
  gameInstance = get_node("/root/proto") 

  var shader = load("res://enemy.gdshader")
  colorShader = ShaderMaterial.new()
  colorShader.shader = shader
  var shaderColorParam = Vector3(1., 1., 1.) if enemyType == ValueObjects.EnemyType.LIGHT else Vector3(0.5, 0.5, 1.)
  colorShader.set_shader_parameter("color", shaderColorParam)
  sprite.material = colorShader


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  if enemyStatus == ValueObjects.EnemyStatus.STRONG:
    move_toward_player()
  else: 
    run_away_from_player()

  move_and_slide()
  set_enemy_status()


func set_enemy_status(): 
  if (gameInstance.actualTimeCycle == ValueObjects.TimeCycle.NIGHT and enemyType == ValueObjects.EnemyType.DARK) \
    or (gameInstance.actualTimeCycle == ValueObjects.TimeCycle.DAY and enemyType == ValueObjects.EnemyType.LIGHT):
    enemyStatus = ValueObjects.EnemyStatus.STRONG 
    label.text = 'stong'
  else: 
    enemyStatus = ValueObjects.EnemyStatus.WEAK 
    label.text = 'weak'


func move_toward_player(): 
  var player = gameInstance.get_node("Player")

  var direction = position.direction_to(player.position)
  if direction:
    velocity.x = direction.x * SPEED
    velocity.y = direction.y * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.y = move_toward(velocity.y, 0, SPEED)


func run_away_from_player(): 
  var player = gameInstance.get_node("Player")

  var direction = position.direction_to(player.position)
  if direction:
    velocity.x = -direction.x * SPEED
    velocity.y = -direction.y * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.y = move_toward(velocity.y, 0, SPEED)


