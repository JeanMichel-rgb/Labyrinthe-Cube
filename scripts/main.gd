extends Node

#region Variables
#region Player
@export_category("Player")
@export var mouse_sensibility : float
@export var player_speed : float
#endregion Player

#region maze
@export_category("Maze")
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
@onready var waiting_screen : Node2D = GUI.get_node("waiting_screen")
@onready var plan_XY : MeshInstance2D = GUI.get_node("position_preview/plans/XY")
@onready var plan_XZ : MeshInstance2D = GUI.get_node("position_preview/plans/XZ")
@onready var plan_YZ : MeshInstance2D = GUI.get_node("position_preview/plans/YZ")
@onready var settings_menu : Node2D = menus.get_node("settings")
#endregion NodesID

#region Window
@onready var window : Window = get_window()
@onready var initial_window_size : Vector2i = window.size
@onready var window_ratio : float = float(window.size.y)/float(window.size.x)
#endregion Window

#region miscellaneous
var maze_complexity : int
var maze_size : int
var global_mouse_position : Vector2 = Vector2.ZERO
var player_position : Vector3i = Vector3i.ZERO
var is_position_visible : bool = false
var settings_menu_open : bool = false
var game_time : float = 0
var previous_game_time : float = 0
#endregion miscellaneous
#endregion Variables

func _ready() -> void:
	update()
	new_game()
	#connect signals
	GUI.get_node("position_preview/is_position_visible").connect("pressed", change_position_visibility)
	settings_menu.get_node("open").connect("pressed", open_close_settings)
	settings_menu.get_node("menu/new_maze").connect("pressed", new_game)
	#set up visibility
	settings_menu.get_node("menu").hide()

func _process(delta: float) -> void:
	game_time += delta
	update()
	vizualize_player_position()
	#win
	if is_player_outside():
		previous_game_time = game_time
		new_game()

#region Update
func update() -> void:
	update_variables()
	update_screen_size()
	update_GUI()

func update_variables():
	global_mouse_position = GUI.get_global_mouse_position()
	player.mouse_sensibility = mouse_sensibility
	player.SPEED = player_speed
	player_position = Vector3i(Vector3(1,1,1)*.5 + player.position)

func vizualize_player_position():
	plan_XY.visible = GUI.get_node("position_preview/is_position_visible").button_pressed
	plan_XZ.visible = is_position_visible
	plan_YZ.visible = is_position_visible
	var player_visualization_position : Vector3 = Vector3(player_position)/float(maze_size-1)
	#XY
	plan_XY.get_node("player").position = (Vector2(1,-1) * -100) + (Vector2(player_visualization_position.x, -player_visualization_position.y) * 200)
	#XZ
	plan_XZ.get_node("player").position = (Vector2(1,-1) * -100) + (Vector2(player_visualization_position.x, -player_visualization_position.z) * 200)
	#YZ
	plan_YZ.get_node("player").position = (Vector2(1,-1) * -100) + (Vector2(player_visualization_position.y, -player_visualization_position.z) * 200)

func update_screen_size() -> void:
	window.size.y = window.size.x * window_ratio

func update_GUI() -> void:
	#region Timers
	var round_to_decimal : int = 3
	GUI.get_node("time/game_time").text = "game's time : "+str(round(game_time*pow(10,round_to_decimal))/pow(10,round_to_decimal))
	GUI.get_node("time/previous_game_time").text = "previous game's time : "+str(round(previous_game_time*pow(10,round_to_decimal))/pow(10,round_to_decimal))
	#endregion Timers
	
	#region GUI's scale
	var ratio : float = float(window.size.x)/float(initial_window_size.x)
	GUI.scale = Vector2(1,1) * ratio
	#endregion GUI's scale
	
	#region Store node's ID
	#store here all Button's ID
	var buttons : Array = [
		settings_menu.get_node("menu/new_maze"),
	]
	#store here all Flat Button's ID
	var flat_buttons : Array = [
		settings_menu.get_node("open"),
	]
	#store here all OptionButton's ID
	var option_buttons : Array = [
		
	]
	#store here all CheckButton's ID
	var check_buttons : Array = [
		GUI.get_node("position_preview/is_position_visible"),
	]
	#store here all CheckBox's ID
	var check_boxs : Array = [
		
	]
	#store here all TextEdit's ID
	var text_edits : Array = [
		
		]
	#store here all LineEdit's ID
	var line_edits : Array = [
		settings_menu.get_node("menu/store_informations/maze_side"),
		settings_menu.get_node("menu/store_informations/maze_complexity"),
	]
	#store here all Label's ID
	var labels : Array = [
		plan_XY.get_node("X"),
		plan_XY.get_node("Y"),
		plan_XY.get_node("0"),
		
		plan_XZ.get_node("X"),
		plan_XZ.get_node("Z"),
		plan_XZ.get_node("0"),
		
		plan_YZ.get_node("Y"),
		plan_YZ.get_node("Z"),
		plan_YZ.get_node("0"),
		
		waiting_screen.get_node("background/Label"),
		
		settings_menu.get_node("menu/texts/maze_side"),
		settings_menu.get_node("menu/texts/maze_complexity"),
		
		GUI.get_node("time/game_time"),
		GUI.get_node("time/previous_game_time"),
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
	
	#region Add StyleBoxFlat to control_node_theme
	for theme_type in ["Button", "0ptionButton", "CheckButton", "CheckBox", "TextEdit", "LineEdit"]:
		control_node_theme.set_stylebox("disabled", theme_type, StyleBoxFlat_disabled)
		control_node_theme.set_stylebox("normal", theme_type, StyleBoxFlat_normal)
		control_node_theme.set_stylebox("focus", theme_type, StyleBoxFlat_focus)
		control_node_theme.set_stylebox("hover", theme_type, StyleBoxFlat_hover)
		control_node_theme.set_stylebox("hover_pressed", theme_type, StyleBoxFlat_hover_pressed)
		control_node_theme.set_stylebox("pressed", theme_type, StyleBoxFlat_pressed)
	#endregion Add StyleBoxFlat to control_node_theme
	#endregion Background
	#endregion Create control node's theme
	
	#region Create flat button's theme
	var flat_button_theme : Theme = Theme.new()
	
	#region Text
	flat_button_theme.set_font("font", "Button", font)
	flat_button_theme.set_color("font_color", "Button", font_color)
	flat_button_theme.set_color("font_disabled_color", "Button", disabled_font_color)
	flat_button_theme.set_color("font_focus_color", "Button", font_color)
	flat_button_theme.set_color("font_hover_color", "Button", font_color*1.5)
	flat_button_theme.set_color("font_pressed_color", "Button", font_selected_color)
	flat_button_theme.set_color("font_outline_color", "Button", font_outline_color)
	flat_button_theme.set_constant("outline_size", "Button", font_outline_size)
	#endregion Text
	
	#region Background
	#region Create the StyleBoxFlat
	_StyleBoxFlat = StyleBoxFlat.new()
	_StyleBoxFlat.bg_color = Color(0,0,0,0)
	#endregion Create the StyleBoxFlat
	
	#region Add StyleBoxFlat to flat_button_theme
	flat_button_theme.set_stylebox("disabled", "Button", _StyleBoxFlat)
	flat_button_theme.set_stylebox("normal", "Button", _StyleBoxFlat)
	flat_button_theme.set_stylebox("focus", "Button", _StyleBoxFlat)
	flat_button_theme.set_stylebox("hover", "Button", _StyleBoxFlat)
	flat_button_theme.set_stylebox("hover_pressed", "Button", _StyleBoxFlat)
	flat_button_theme.set_stylebox("pressed", "Button", _StyleBoxFlat)
	#endregion Add StyleBoxFlat to flat_button_theme
	#endregion Background
	#endregion Create flat button's theme
	
	#region Add theme
	for button in buttons:
		button.theme = control_node_theme
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	for flat_button in flat_buttons:
		flat_button.theme = flat_button_theme
		flat_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	for option_button in option_buttons:
		option_button.theme = control_node_theme
		option_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	for check_button in check_buttons:
		check_button.theme = control_node_theme
		check_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		check_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	
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
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	#endregion Add label settings
	#endregion Labels
	
	#create a dictionary with all nodes that can be focused
	var control_nodes : Dictionary = {
		"buttons" = buttons,
		"flat_buttons" = flat_buttons,
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

#region Utilities
func is_player_outside() -> bool:
	return player_position.x >= maze_size or player_position.y >= maze_size or player_position.z >= maze_size

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

func create_maze(side : int, complexity : int) -> void:
	show_waiting_screen()
	await sleep(.1)
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
	await draw_maze(maze_grid, side)
	hide_waiting_screen()

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
	for cube in maze.get_children():
		cube.queue_free()
	for z in side:
		for y in side:
			for x in side:
				if maze_grid[from_Vector3i_to_grid_position(Vector3i(x,y,z), side)] == 0:
					new_cube(Vector3(x,y,z))
	await sleep()

func show_waiting_screen() -> void:
	waiting_screen.show()
	waiting_screen.z_index = 3
	waiting_screen.get_node("background").mesh.size = initial_window_size
	waiting_screen.get_node("background").position = initial_window_size/2

func hide_waiting_screen() -> void:
	waiting_screen.hide()

func sleep(delta : float = 0.01) -> void:
	await get_tree().create_timer(delta).timeout
#endregion utilities

#region Buttons
func change_position_visibility():
	is_position_visible = !is_position_visible

func new_game():
	#maze_complexity is the random in the maze:
		#maze_complexity = 0 : one single path
		#maze_complexity = 1 : all walls are breaked
		#maze_complexity = 2 : 1/2 walls are breaked
		#maze_complexity = 3 : 1/3 walls are breaked
		#...
	settings_menu_open = false
	settings_menu.get_node("menu").hide()
	maze_complexity = abs(settings_menu.get_node("menu/store_informations/maze_complexity").text.to_int())
	maze_size = abs(settings_menu.get_node("menu/store_informations/maze_side").text.to_int())
	
	maze_size = abs(maze_size) + (abs(maze_size)+1)%2
	if maze_size < 5:
		maze_size = 5
	
	game_time = 0
	
	player.position = Vector3(1,1,1)
	create_maze(maze_size,maze_complexity)

func open_close_settings():
	settings_menu_open = !settings_menu_open
	settings_menu.get_node("menu").visible = settings_menu_open
#endregion
