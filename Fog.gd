extends Sprite

const DIMENSIONS = Vector2(1920, 1080)
const SCALE = 16

var fog_image = Image.new()
var fog_texture = ImageTexture.new()

var revealed: Dictionary = {}

func _ready():
	scale *= SCALE
	# Create Image
	fog_image.create(DIMENSIONS.x, DIMENSIONS.y, false, Image.FORMAT_RGBAH)
	# Fill Fog
	fog_image.fill(Color(0, 0, 0, 1.0))
	# Set Sprite Texture
	fog_texture.create_from_image(fog_image)
	set_texture(fog_texture)

func reset():
	revealed = {}
	fog_image.lock()
	fog_image.fill(Color(0, 0, 0, 1.0))
	fog_image.unlock()
	fog_texture.create_from_image(fog_image)
	set_texture(fog_texture)

func _show_bloid(bloid: Node2D, size: float):
	var origin = (Vector2.ONE * size) / 2.0
	var light_offset = DIMENSIONS / 2.0 - origin
	var light_image = Image.new()
	light_image.create(size, size, false, Image.FORMAT_RGBAH)
	light_image.lock()
	for x in range(size):
		for y in range(size):
			var color = Color(1, 1, 1, 0)
			var dist = Vector2(x, y).distance_to(origin)
			if dist < size / 2.0:
				color.a = 1 - dist/(size/2)
			light_image.set_pixel(x, y, color)
	light_image.unlock()

	revealed[bloid] = light_image
	
	fog_image.lock()
	fog_image.blend_rect(
		light_image,
		Rect2(Vector2.ZERO, Vector2.ONE * size),
		light_offset + (bloid.position/SCALE)
	)
	fog_image.unlock()

func reveal_bloid(bloid: Node2D, size: float = 64):
	if revealed.has(bloid):
		if revealed[bloid].get_width() != size:
			_hide_bloid(bloid)
		else:
			return
	_show_bloid(bloid, size)
	fog_texture.create_from_image(fog_image)
	set_texture(fog_texture)

func _hide_bloid(bloid: Node2D):
	revealed.erase(bloid)
	fog_image.lock()
	fog_image.fill(Color(0, 0, 0, 1.0))
	for b in revealed:
		var light_image = revealed[b]
		var size = light_image.get_width()
		var light_offset = DIMENSIONS / 2.0 - (Vector2.ONE * size) / 2.0
		fog_image.blend_rect(
			light_image,
			Rect2(Vector2.ZERO, Vector2.ONE * size),
			light_offset + (b.position/SCALE)
		)
	fog_image.unlock()

func hide_bloid(bloid: Node2D):
	if not revealed.has(bloid):
		return
	_hide_bloid(bloid)
	fog_texture.create_from_image(fog_image)
	set_texture(fog_texture)
