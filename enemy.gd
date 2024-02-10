extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var label = $Label

const SPEED = 300.0

var enemyType: ValueObjects.EnemyType
var enemyStatus: ValueObjects.EnemyStatus

var gameInstance: Node2D
var colorShader: ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
  enemyType = randi_range(0,1) as ValueObjects.EnemyType
  gameInstance = get_parent()

  var shader = load("res://enemy.gdshader")
  colorShader = ShaderMaterial.new()
  colorShader.shader = shader
  var shaderColorParam = Vector3(1., 1., 1.) if enemyType == ValueObjects.EnemyType.LIGHT else Vector3(0.5, 0.5, 1.)
  colorShader.set_shader_parameter("color", shaderColorParam)
  sprite.material = colorShader
  set_enemy_status()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  var player = gameInstance.get_node("Player")

  var direction = position.direction_to(player.position)
  if direction:
    velocity.x = direction.x * SPEED
    velocity.y = direction.y * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.y = move_toward(velocity.y, 0, SPEED)

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
