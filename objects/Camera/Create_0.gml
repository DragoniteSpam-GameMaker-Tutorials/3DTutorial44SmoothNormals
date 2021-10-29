/// @description Set up 3D things

// Bad things happen if you turn off the depth buffer in 3D
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);

gpu_set_cullmode(cull_counterclockwise);

view_mat = undefined;
proj_mat = undefined;

#region vertex format setup
// Vertex format: data must go into vertex buffers in the order defined by this
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_color();
vertex_format = vertex_format_end();
#endregion

#region create the grid
ground = vertex_create_buffer();
vertex_begin(ground, vertex_format);

// Create a checkerboard pattern on the floor
var s = 128;

var xtex = room_width / sprite_get_width(spr_grass);
var ytex = room_height / sprite_get_height(spr_grass);
var color = c_white;

vertex_add_point(ground, 0, 0, 0,                          0, 0, 1,        0, 0,       color, 1);
vertex_add_point(ground, room_width, 0, 0,                 0, 0, 1,        xtex, 0,       color, 1);
vertex_add_point(ground, room_width, room_height, 0,       0, 0, 1,        xtex, ytex,       color, 1);

vertex_add_point(ground, room_width, room_height, 0,       0, 0, 1,        xtex, ytex,       color, 1);
vertex_add_point(ground, 0, room_height, 0,                0, 0, 1,        0, ytex,       color, 1);
vertex_add_point(ground, 0, 0, 0,                          0, 0, 1,        0, 0,       color, 1);

vertex_end(ground);
#endregion

instance_create_depth(0, 0, 0, Player);

znear = 1;
zfar = 32000;

vb_merry = scr_calculate_normals(load_model("merry.d3d"));

vb_sphere = load_model("sphere.d3d");
vb_sphere_flat = load_model("sphere-flat.d3d");
vb_sphere_smooth = load_model("sphere-smooth.d3d");