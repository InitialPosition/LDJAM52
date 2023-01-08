function scr_pathfinding_init() {
	pathfinding_grid = mp_grid_create(16, 16, 38, 18, 16, 16);
	mp_grid_add_instances(pathfinding_grid, obj_wall, true);
	mp_grid_add_instances(pathfinding_grid, obj_bed_collider, true);
}

function scr_pathfinding_get_path(_caller, _target) {
	mp_grid_path(obj_pathfinding_manager.pathfinding_grid, _caller.current_path, _caller.x + 8, _caller.y + 8, _target.x + 8, _target.y - 8, true);
}
