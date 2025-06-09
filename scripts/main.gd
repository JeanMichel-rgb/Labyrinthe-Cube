extends Node

#region Variables
#region Player
@export_category("Player")
@export var mouse_sensibility : float
@export var player_speed : float
#endregion Player

#region maze
@export_category("Maze")
@export var maze_size : int
@export var top_cube_color : Color
@export var down_cube_color : Color
@export var right_cube_color : Color
@export var left_cube_color : Color
@export var front_cube_color : Color
@export var behind_cube_color : Color
#endregion

#region GUI
@export_category("Text")
@export var font : Font
@export var font_color : Color
@export var disabled_font_alpha : float
@onready var disabled_font_color : Color = Color(font_color, disabled_font_alpha)
@export var font_selected_color : Color
@export var selection_color : Color
@export var font_outline_color : Color
@export var font_outline_size : int

@export_category("GUI")
@export var GUI_bg_color : Color
@export var GUI_outline_color : Color
@export var GUI_disabled_alpha : float
@onready var GUI_disabled_color : Color = Color(GUI_bg_color, GUI_disabled_alpha)
@onready var GUI_disabled_outline_color : Color = Color(GUI_outline_color, GUI_disabled_alpha)
@export var GUI_outline_size : int
@export var GUI_corner_radius : Vector4i

@export_category("Menus")
@export var menus_bg_image : CompressedTexture2D
@export var menus_bg_color : Color
#endregion GUI

#region NodesID
@onready var GUI : Node2D = get_node("GUI")
@onready var menus : Node2D = get_node("GUI/menus")
@onready var world : Node3D = get_node("world")
@onready var maze : Node3D = world.get_node("maze")
@onready var player : CharacterBody3D = world.get_node("player")
#endregion NodesID

#region Window
@onready var window : Window = get_window()
@onready var initial_window_size : Vector2i = window.size
@onready var window_ratio : float = float(window.size.y)/float(window.size.x)
#endregion Window

#region miscellaneous
var global_mouse_position : Vector2 = Vector2.ZERO
#endregion miscellaneous
#endregion Variables

func _ready() -> void:
	create_maze(maze_size,0)
	player.position = Vector3(1,1,1)

func _process(delta: float) -> void:
	update()

#region Update
func update() -> void:
	update_variables()
	update_screen_size()
	update_GUI()

func update_variables():
	global_mouse_position = GUI.get_global_mouse_position()
	player.mouse_sensibility = mouse_sensibility
	player.SPEED = player_speed

func update_screen_size() -> void:
	window.size.y = window.size.x * window_ratio

func update_GUI() -> void:
	#region GUI's scale
	var ratio : float = float(window.size.x)/float(initial_window_size.x)
	GUI.scale = Vector2(1,1) * ratio
	#endregion GUI's scale
	
	#region Store node's ID
	#store here all Button's ID
	var buttons : Array = [
		
	]
	#store here all OptionButton's ID
	var option_buttons : Array = [
		
	]
	#store here all CheckButton's ID
	var check_buttons : Array = [
		
	]
	#store here all CheckBox's ID
	var check_boxs : Array = [
		
	]
	#store here all TextEdit's ID
	var text_edits : Array = [
		
		]
	#store here all LineEdit's ID
	var line_edits : Array = [
		
	]
	#store here all Label's ID
	var labels : Array = [
		
	]
	#endregion Store node's ID
	
	#region Themes
	#region Create control node's theme
	var control_node_theme : Theme = Theme.new()
	
	#region Text
	#region Button
	control_node_theme.set_font("font", "Button", font)
	control_node_theme.set_color("font_color", "Button", font_color)
	control_node_theme.set_color("font_disabled_color", "Button", disabled_font_color)
	control_node_theme.set_color("font_focus_color", "Button", font_color)
	control_node_theme.set_color("font_hover_color", "Button", font_color*1.5)
	control_node_theme.set_color("font_pressed_color", "Button", font_selected_color)
	control_node_theme.set_color("font_outline_color", "Button", font_outline_color)
	control_node_theme.set_constant("outline_size", "Button", font_outline_size)
	#endregion Button
	
	#region 0ptionButton
	control_node_theme.set_font("font", "0ptionButton", font)
	control_node_theme.set_color("font_color", "0ptionButton", font_color)
	control_node_theme.set_color("font_disabled_color", "0ptionButton", disabled_font_color)
	control_node_theme.set_color("font_focus_color", "0ptionButton", font_color)
	control_node_theme.set_color("font_hover_color", "0ptionButton", font_color*1.5)
	control_node_theme.set_color("font_hover_pressed_color", "0ptionButton", font_color*1.5)
	control_node_theme.set_color("font_pressed_color", "0ptionButton", font_color)
	control_node_theme.set_color("font_outline_color", "0ptionButton", font_outline_color)
	control_node_theme.set_constant("outline_size", "0ptionButton", font_outline_size)
	#endregion 0ptionButton
	
	#region CheckButton
	control_node_theme.set_font("font", "CheckButton", font)
	control_node_theme.set_color("font_color", "CheckButton", font_color)
	control_node_theme.set_color("font_disabled_color", "CheckButton", disabled_font_color)
	control_node_theme.set_color("font_focus_color", "CheckButton", font_color)
	control_node_theme.set_color("font_hover_color", "CheckButton", font_color*1.5)
	control_node_theme.set_color("font_hover_pressed_color", "CheckButton", font_color*1.5)
	control_node_theme.set_color("font_pressed_color", "CheckButton", font_color)
	control_node_theme.set_color("font_outline_color", "CheckButton", font_outline_color)
	control_node_theme.set_constant("outline_size", "CheckButton", font_outline_size)
	#endregion CheckButton
	
	#region CheckBox
	control_node_theme.set_font("font", "CheckBox", font)
	control_node_theme.set_color("font_color", "CheckBox", font_color)
	control_node_theme.set_color("font_disabled_color", "CheckBox", disabled_font_color)
	control_node_theme.set_color("font_focus_color", "CheckBox", font_color)
	control_node_theme.set_color("font_hover_color", "CheckBox", font_color*1.5)
	control_node_theme.set_color("font_hover_pressed_color", "CheckBox", font_color*1.5)
	control_node_theme.set_color("font_pressed_color", "CheckBox", font_color)
	control_node_theme.set_color("font_outline_color", "CheckBox", font_outline_color)
	control_node_theme.set_constant("outline_size", "CheckBox", font_outline_size)
	#endregion CheckBox
	
	#region TextEdit
	control_node_theme.set_font("font", "TextEdit", font)
	control_node_theme.set_color("font_placeholder_color", "TextEdit", disabled_font_color)
	control_node_theme.set_color("font_color", "TextEdit", font_color)
	control_node_theme.set_color("font_readonly_color", "TextEdit", font_color)
	control_node_theme.set_color("font_selected_color", "TextEdit", font_selected_color)
	control_node_theme.set_color("selection_color", "TextEdit", selection_color)
	control_node_theme.set_color("font_outline_color", "TextEdit", font_outline_color)
	control_node_theme.set_constant("outline_size", "TextEdit", font_outline_size)
	#endregion TextEdit
	
	#region LineEdit
	control_node_theme.set_font("font", "LineEdit", font)
	control_node_theme.set_color("font_color", "LineEdit", font_color)
	control_node_theme.set_color("font_selected_color", "LineEdit", font_selected_color)
	control_node_theme.set_color("selection_color", "LineEdit", selection_color)
	control_node_theme.set_color("font_uneditable_color", "LineEdit", disabled_font_color)
	control_node_theme.set_color("font_outline_color", "LineEdit", font_outline_color)
	control_node_theme.set_constant("outline_size", "LineEdit", font_outline_size)
	#endregion LineEdit
	#endregion Text
	
	#region Background
	#region Create the StyleBoxFlat template
	var _StyleBoxFlat : StyleBoxFlat = StyleBoxFlat.new()
	_StyleBoxFlat.bg_color = GUI_bg_color
	_StyleBoxFlat.corner_radius_top_left = GUI_corner_radius.x
	_StyleBoxFlat.corner_radius_top_right = GUI_corner_radius.y
	_StyleBoxFlat.corner_radius_bottom_left = GUI_corner_radius.z
	_StyleBoxFlat.corner_radius_bottom_right = GUI_corner_radius.w
	_StyleBoxFlat.border_width_bottom = GUI_outline_size
	_StyleBoxFlat.border_width_left = GUI_outline_size
	_StyleBoxFlat.border_width_top = GUI_outline_size
	_StyleBoxFlat.border_width_right = GUI_outline_size
	_StyleBoxFlat.border_color = GUI_outline_color
	#endregion Create the StyleBoxFlat template
	
	#region Adapt to multiples StyleBoxFlat
	#disabled
	var StyleBoxFlat_disabled : StyleBoxFlat = _StyleBoxFlat.duplicate()
	StyleBoxFlat_disabled.bg_color = GUI_disabled_color
	StyleBoxFlat_disabled.border_color = GUI_disabled_outline_color
	#normal
	var StyleBoxFlat_normal : StyleBoxFlat = _StyleBoxFlat.duplicate()
	#focus
	var StyleBoxFlat_focus : StyleBoxFlat = _StyleBoxFlat.duplicate()
	#hover
	var StyleBoxFlat_hover : StyleBoxFlat = _StyleBoxFlat.duplicate()
	StyleBoxFlat_disabled.bg_color *= 1.5
	#hover pressed
	var StyleBoxFlat_hover_pressed : StyleBoxFlat = StyleBoxFlat_hover.duplicate()
	#pressed
	var StyleBoxFlat_pressed : StyleBoxFlat = StyleBoxFlat_hover.duplicate()
	#endregion Adapt to multiples StyleBoxFlat
	
	#region Add backgrounds to control_node_theme
	for theme_type in ["Button", "0ptionButton", "CheckButton", "CheckBox", "TextEdit", "LineEdit"]:
		control_node_theme.set_stylebox("disabled", theme_type, StyleBoxFlat_disabled)
		control_node_theme.set_stylebox("normal", theme_type, StyleBoxFlat_normal)
		control_node_theme.set_stylebox("focus", theme_type, StyleBoxFlat_focus)
		control_node_theme.set_stylebox("hover", theme_type, StyleBoxFlat_hover)
		control_node_theme.set_stylebox("hover_pressed", theme_type, StyleBoxFlat_hover_pressed)
		control_node_theme.set_stylebox("pressed", theme_type, StyleBoxFlat_pressed)
	#endregion Add backgrounds to control_node_theme
	#endregion Background
	#endregion Create control node's theme
	
	#region Add theme
	for button in buttons:
		button.theme = control_node_theme
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	for option_button in option_buttons:
		option_button.theme = control_node_theme
		option_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	for check_button in check_buttons:
		check_button.theme = control_node_theme
		check_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	for check_box in check_boxs:
		check_box.theme = control_node_theme
		check_box.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		check_box.alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	for text_edit in text_edits:
		text_edit.theme = control_node_theme
	
	for line_edit in line_edits:
		line_edit.theme = control_node_theme
	#endregion Add theme
	#endregion Themes
	
	#region Labels
	#region Create label settings
	var label_settings : LabelSettings = LabelSettings.new()
	label_settings.font = font
	label_settings.font_color = font_color
	label_settings.outline_color = font_outline_color
	label_settings.outline_size = font_outline_size
	#endregion Create label settings
	
	#region Add label settings
	for label in labels:
		label.label_settings = label_settings
	#endregion Add label settings
	#endregion Labels
	
	#create a dictionary with all nodes that can be focused
	var control_nodes : Dictionary = {
		"buttons" = buttons,
		"option_buttons" = option_buttons,
		"check_buttons" = check_buttons,
		"check_boxs" = check_boxs,
		"text_edits" = text_edits,
		"line_edits" = line_edits,
	}
	update_focus(control_nodes)

func update_focus(control_nodes : Dictionary) -> void:
	for node_type in control_nodes:
		for node in control_nodes[node_type]:
			if node.has_focus():
				if Input.is_action_just_pressed("click"):
					#get rectangle's global transform
					var rectangle_UpLeft_position : Vector2 = node.get_global_rect().position
					var rectangle_diagonal : Vector2 = node.get_global_rect().size
					var rectangle_rotation : float = node.get_global_transform().get_rotation()
					if not is_in_rectangle(global_mouse_position, rectangle_UpLeft_position, rectangle_diagonal, rectangle_rotation):
						node.release_focus()
#endregion Update

#region utilities
func is_in_rectangle(position : Vector2, rectangle_UpLeft_position : Vector2, rectangle_diagonal : Vector2, rectangle_rotation : float) -> bool:
	#recalculate the position based on rectangle's position and rotation
	position -= rectangle_UpLeft_position
	position = Vector2.from_angle(-rectangle_rotation + position.angle())*position.length()
	#check if position is in rectangle
	return (
		(position.x >= 0 and position.y >= 0) and
		(position.x <= rectangle_diagonal.x and position.y <= rectangle_diagonal.y)
	)

func new_cube(position : Vector3, scale : Vector3 = Vector3(1,1,1), rotation : Vector3 = Vector3.ZERO) -> void:
	var cube_node : Node3D = Node3D.new()
	
	cube_node.position = position
	cube_node.scale = scale
	cube_node.rotation = rotation
	
	#region Cube Mesh
	var cube_mesh : Node3D = Node3D.new()
	cube_node.add_child(cube_mesh)
	var cube_mesh_top : MeshInstance3D = MeshInstance3D.new()
	cube_mesh_top.mesh = QuadMesh.new()
	var cube_mesh_down : MeshInstance3D = cube_mesh_top.duplicate()
	var cube_mesh_left : MeshInstance3D = cube_mesh_top.duplicate()
	var cube_mesh_right : MeshInstance3D = cube_mesh_top.duplicate()
	var cube_mesh_front : MeshInstance3D = cube_mesh_top.duplicate()
	var cube_mesh_behind : MeshInstance3D = cube_mesh_top.duplicate()
	
	cube_mesh.add_child(cube_mesh_top)
	cube_mesh.add_child(cube_mesh_down)
	cube_mesh.add_child(cube_mesh_left)
	cube_mesh.add_child(cube_mesh_right)
	cube_mesh.add_child(cube_mesh_front)
	cube_mesh.add_child(cube_mesh_behind)
	#endregion Cube Mesh
	
	#region Mesh's position
	cube_mesh_top.position.y += .5
	cube_mesh_top.rotation.x = -PI/2
	cube_mesh_down.position.y -= .5
	cube_mesh_down.rotation.x = PI/2
	cube_mesh_left.position.x -= .5
	cube_mesh_left.rotation.y -= PI/2
	cube_mesh_right.position.x += .5
	cube_mesh_right.rotation.y += PI/2
	cube_mesh_front.position.z += .5
	cube_mesh_behind.position.z -= .5
	cube_mesh_behind.scale.z = -1
	#endregion Mesh's position
	
	#region Color
	var top_color : StandardMaterial3D = StandardMaterial3D.new()
	top_color.albedo_color = top_cube_color
	top_color.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	var down_color : StandardMaterial3D = top_color.duplicate()
	down_color.albedo_color = down_cube_color
	
	var left_color : StandardMaterial3D = top_color.duplicate()
	left_color.albedo_color = left_cube_color
	
	var right_color : StandardMaterial3D = top_color.duplicate()
	right_color.albedo_color = right_cube_color
	
	var front_color : StandardMaterial3D = top_color.duplicate()
	front_color.albedo_color = front_cube_color
	
	var behind_color : StandardMaterial3D = top_color.duplicate()
	behind_color.albedo_color = behind_cube_color
	
	cube_mesh_top.set_surface_override_material(0, top_color)
	cube_mesh_down.set_surface_override_material(0, down_color)
	cube_mesh_left.set_surface_override_material(0, left_color)
	cube_mesh_right.set_surface_override_material(0, right_color)
	cube_mesh_front.set_surface_override_material(0, front_color)
	cube_mesh_behind.set_surface_override_material(0, behind_color)
	#endregion Color
	
	#region StaticBody
	var StaticBody : StaticBody3D = StaticBody3D.new()
	var CollisionShape : CollisionShape3D = CollisionShape3D.new()
	CollisionShape.shape = BoxShape3D.new()
	StaticBody.add_child(CollisionShape)
	cube_node.add_child(StaticBody)
	#endregion StaticBody
	
	maze.add_child(cube_node)


#complexity is the random in the maze:
#complexity = 0 : one single path
#complexity = 1 : all walls are breaked
#complexity = 2 : 1/2 walls are breaked
#complexity = 3 : 1/3 walls are breaked
#...
func create_maze(side : int, complexity : int) -> void:
	side = abs(side) + (abs(side)+1)%2
	if side < 3:
		side = 3
	complexity = abs(complexity)
	var maze_grid : Array = []
	var walls_position : Array = []
	#region Initialize maze grid
	var value = 0
	for z in side:
		for y in side:
			for x in side:
				if z % 2 == 0 or y % 2 == 0 or x % 2 == 0:
					maze_grid.append(0)
					if is_x_wall(Vector3i(x,y,z),side) or is_y_wall(Vector3i(x,y,z),side) or is_z_wall(Vector3i(x,y,z),side):
						walls_position.append(Vector3i(x,y,z))
				else : 
					value += 1
					maze_grid.append(value)
	#endregion Initialize maze grid
	#region Create Maze
	var final_value : int
	for i in walls_position.size():
		var wall_position : Vector3i = walls_position.pick_random()
		walls_position.remove_at(walls_position.find(wall_position))
		var front : float
		var behind : float
		if is_x_wall(wall_position, side):
			front = maze_grid[from_Vector3i_to_grid_position(wall_position+Vector3i(1,0,0), side)]
			behind = maze_grid[from_Vector3i_to_grid_position(wall_position-Vector3i(1,0,0), side)]
		if is_y_wall(wall_position, side):
			front = maze_grid[from_Vector3i_to_grid_position(wall_position+Vector3i(0,1,0), side)]
			behind = maze_grid[from_Vector3i_to_grid_position(wall_position-Vector3i(0,1,0), side)]
		if is_z_wall(wall_position, side):
			front = maze_grid[from_Vector3i_to_grid_position(wall_position+Vector3i(0,0,1), side)]
			behind = maze_grid[from_Vector3i_to_grid_position(wall_position-Vector3i(0,0,1), side)]
		
		var wall_grid_position = from_Vector3i_to_grid_position(wall_position, side)
		if front != null and behind != null:
			if front != behind or (randi_range(1,complexity) == 1 and complexity >= 1):
				maze_grid[wall_grid_position] = front
				maze_grid = replace_all_in(maze_grid, behind, front)
				final_value = front
	maze_grid[from_Vector3i_to_grid_position(Vector3i(side-1,side-2,side-2), side)] = 1
	maze_grid = replace_all_in(maze_grid, final_value, 1)
	#endregion Create Maze
	draw_maze(maze_grid, side)

func from_Vector3i_to_grid_position(Vector : Vector3i, side : int) -> int:
	return Vector.z * pow(side,2) + Vector.y * pow(side,1) + Vector.x * pow(side,0)

func is_x_wall(position : Vector3i, side : int) -> bool:
	return position.x != 0 and position.x != side-1 and position.x % 2 == 0 and position.y % 2 == 1 and position.z % 2 == 1

func is_y_wall(position : Vector3i, side : int) -> bool:
	return position.x % 2 == 1 and position.y != 0 and position.y != side-1 and position.y % 2 == 0 and position.z % 2 == 1

func is_z_wall(position : Vector3i, side : int) -> bool:
	return position.x % 2 == 1 and position.y % 2 == 1 and position.z != 0 and position.z != side-1 and position.z % 2 == 0

func replace_all_in(array : Array, replaced_value : float, new_value : float) -> Array:
	for i in array.size():
		if array[i] == replaced_value:
			array[i] = new_value
	return array

func draw_maze(maze_grid : Array, side : int) -> void:
	for z in side:
		for y in side:
			for x in side:
				if maze_grid[from_Vector3i_to_grid_position(Vector3i(x,y,z), side)] == 0:
					new_cube(Vector3(x,y,z))
#endregion utilities
