function scr_bed_init() {
	priority = 2;
	priority_harvested = 1;
	
	action_required = false;
	harvested = false;
	
	action_interval_min = 720;
	action_interval_max = 1200;
	
	alarm[0] = irandom_range(action_interval_min, action_interval_max);
	
	// draw beds behind everything
	depth += 1;
}

function scr_bed_call_nurse() {
	// call the next free nurse to this bed
	
	if !action_required {
		action_required = true;
		var _target = instance_create_layer(x, y, "Targets", obj_npc_target);
		_target.target_priority = priority;
		_target.destroy_on_finish = true;
	}
}

function scr_bed_reset() {
	// reset the alarm indefinitely
	alarm[0] = irandom_range(action_interval_min, action_interval_max);
	action_required = false;
	harvested = false;
}

function scr_bed_harvest() {
	if !harvested {
		// stop auto calling immediately
		alarm[0] = -1;
		
		// give player blood
		obj_game_manager.blood_level += irandom_range(2, 3);
		if obj_game_manager.blood_level > obj_game_manager.blood_level_max {
			obj_game_manager.blood_level = obj_game_manager.blood_level_max;
		}
		
		// spawn a high priority target
		action_required = true;
		harvested = true;
		var _target = instance_create_layer(x, y, "Targets", obj_npc_target);
		_target.target_priority = priority_harvested;
		_target.destroy_on_finish = true;
	}
}

function scr_bed_draw() {
	// draw the bed itself
	draw_self();
	
	// draw blood bag depending on fill status
	draw_sprite(spr_bloodbag, harvested, x + 32, y - 16);
}
