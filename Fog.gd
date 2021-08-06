extends Sprite

const LIGHT_SIZE = 128
const SCALE = 16

var fogImage = Image.new()
var fogTexture = ImageTexture.new()
var lightImage = Image.new()
var lightTexture = ImageTexture.new()

var revealed: Array = []

var light_offset: Vector2 = Vector2.ZERO

func _ready():
	light_offset = Vector2(1920.0 / 2.0, 1080.0 / 2.0) - Vector2(LIGHT_SIZE / 2.0, LIGHT_SIZE / 2.0)
	scale *= SCALE
	# Create Images
	fogImage.create(1920, 1080, false, Image.FORMAT_RGBAH)
	
	lightImage.create(LIGHT_SIZE, LIGHT_SIZE, false, Image.FORMAT_RGBAH)
	# Fill Fog
	fogImage.fill(Color(0, 0, 0, 1.0))
	# Fill Light
	lightImage.lock()
	for x in range(LIGHT_SIZE):
		for y in range(LIGHT_SIZE):
			var color = Color(1, 1, 1, 0)
			var dist = Vector2(x, y).distance_to(Vector2(LIGHT_SIZE/2, LIGHT_SIZE/2))
			if dist < LIGHT_SIZE / 2.0:
				color.a = 1 - dist/(LIGHT_SIZE/2)
			lightImage.set_pixel(x, y, color)
	lightImage.unlock()
	lightTexture.create_from_image(lightImage)
	# Set Sprite Texture
	fogTexture.create_from_image(fogImage)
	set_texture(fogTexture)

func reset():
	revealed = []
	fogImage.lock()
	fogImage.fill(Color(0, 0, 0, 1.0))
	fogImage.unlock()
	fogTexture.create_from_image(fogImage)
	set_texture(fogTexture)

func reveal_bloid(bloid: Bloid):
	if revealed.has(bloid):
		return
	revealed.append(bloid)
	fogImage.lock()
	
	fogImage.blend_rect(
		lightImage,
		Rect2(Vector2.ZERO, Vector2(LIGHT_SIZE, LIGHT_SIZE)),
		light_offset + (bloid.position/SCALE)
	)
	
	fogImage.unlock()
	fogTexture.create_from_image(fogImage)
	set_texture(fogTexture)
	

func hide_bloid(bloid: Bloid):
	# TODO
	return
