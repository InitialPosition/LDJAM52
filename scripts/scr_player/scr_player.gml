function scr_player_init() {
	// declare base variables
	
	movement_speed = 1;
	normalized_move_mod = sqrt(movement_speed);
	movement_speed_sprint = 2;
	normalized_move_mod_sprint = sqrt(movement_speed_sprint);
	
	key_move_left = vk_left;
	key_move_right = vk_right;
	key_move_up = vk_up;
	key_move_down = vk_down;
	key_sprint = vk_shift;
	key_interact = ord("E");
	
	left_pressed = false;
	right_pressed = false;
	up_pressed = false;
	down_pressed = false;
	interact_pressed = false;
	interact_held = false;
	
	last_bed = noone;
	draw_indicator = false;
	draw_disabled = false;
	
	xx = 0;
	yy = 0;
}

function scr_player_update() {
	scr_player_read_input();
	scr_player_handle_interactions();
	scr_player_set_movement_vectors();
	scr_player_handle_collision();
	
	// bed indicator
	draw_indicator = place_meeting(x, y, obj_bed) and !draw_disabled and !instance_nearest(x, y, obj_bed).harvested;
	
	// apply movement vectors
	x += xx;
	y += yy;
}

function scr_player_read_input() {
	// read the input and set the movement variables accordingly
	left_pressed = keyboard_check(key_move_left);
	right_pressed = keyboard_check(key_move_right);
	up_pressed = keyboard_check(key_move_up);
	down_pressed = keyboard_check(key_move_down);
	sprint_pressed = keyboard_check(key_sprint);
	
	interact_pressed = keyboard_check_pressed(key_interact);
	interact_held = keyboard_check(key_interact);
}

function scr_player_handle_interactions() {
	if interact_pressed {
		if place_meeting(x, y, obj_bed) {
			if !instance_exists(obj_harvest_action) and !last_bed.harvested {
				// create a harvest action and therefore lock player
				var _harvest_action = instance_create_layer(x, y, "Instances", obj_harvest_action);
				scr_harvest_set_bed_target(_harvest_action, last_bed);
				
				sprite_index = spr_player_harvest;
				draw_disabled = true;
			}
		}
	}
}

function scr_player_update_last_bed() {
	last_bed = other.id;
}

function scr_player_set_movement_vectors() {
	
	// if currently harvesting, disable controls and regain sprint
	if instance_exists(obj_harvest_action) {
		with obj_game_manager {
			scr_game_manager_regain_sprinting();
		}
		
		xx = 0;
		yy = 0;
		
		exit;
	}
	
	// set the players movement vectors according to which buttons are pressed
	if !sprint_pressed or !obj_game_manager.can_sprint {
		xx = (movement_speed * left_pressed * -1) + (movement_speed * right_pressed);
		yy = (movement_speed * up_pressed * -1) + (movement_speed * down_pressed);
	
		// normalize movement if moving diagonally
		if xx != 0 && yy != 0 {
			xx = (normalized_move_mod * (sqrt(abs(xx)))) * sign(xx);
			yy = (normalized_move_mod * (sqrt(abs(yy)))) * sign(yy);
		}
		
		// refill sprint meter
		with obj_game_manager {
			scr_game_manager_regain_sprinting();
		}
		
	} else {
		xx = (movement_speed_sprint * left_pressed * -1) + (movement_speed_sprint * right_pressed);
		yy = (movement_speed_sprint * up_pressed * -1) + (movement_speed_sprint * down_pressed);
	
		// normalize movement if moving diagonally
		if xx != 0 && yy != 0 {
			xx = (normalized_move_mod_sprint * (sqrt(abs(xx)))) * sign(xx);
			yy = (normalized_move_mod_sprint * (sqrt(abs(yy)))) * sign(yy);
		}
		
		// drain sprinting meter if actually moving
		if xx != 0 or yy != 0 {
			obj_game_manager.sprint_energy -= obj_game_manager.sprint_drain_rate;
			if obj_game_manager.sprint_energy <= 0 {
				obj_game_manager.sprint_energy = 0;
				obj_game_manager.can_sprint = false;
			}
		} else {
			with obj_game_manager {
				scr_game_manager_regain_sprinting();
			}
		}
	}
	
	if xx != 0 or yy != 0 {
		sprite_index = spr_player_walk;
	} else {
		sprite_index = spr_player_idle;
	}
}

function scr_player_handle_collision() {
	// stop player if going to run into a wall
	
	if place_meeting(x + xx, y, obj_wall) {
		if sign(xx) == 1 {
			move_contact_solid(0, abs(xx));
		} else {
			move_contact_solid(180, abs(xx));
		}
		xx = 0;
	}
	if place_meeting(x, y + yy, obj_wall) {
		if sign(yy) == 1 {
			move_contact_solid(270, abs(yy));
		} else {
			move_contact_solid(90, abs(yy));
		}
		yy = 0;
	}
	
	if place_meeting(x + xx, y, obj_bed_collider) {
		if sign(xx) == 1 {
			move_contact_solid(0, abs(xx));
		} else {
			move_contact_solid(180, abs(xx));
		}
		xx = 0;
	}
	if place_meeting(x, y + yy, obj_bed_collider) {
		if sign(yy) == 1 {
			move_contact_solid(270, abs(yy));
		} else {
			move_contact_solid(90, abs(yy));
		}
		yy = 0;
	}
}

function scr_player_collision_corner_fix() {
	// fix the player being stuck in walls if they manage to hit the corner pixel perfect
	
	if !place_meeting(x, y, obj_wall) {
		x += xx;
	}
}

function scr_player_draw() {
	draw_self();
	
	if draw_indicator {
		draw_sprite(spr_activate, 0, x + 12, y);
	}
}
