function scr_target_init(_id, _priority) {
	target_id = _id;					// target id
	target_priority = _priority;		// lower values are higher priority targets
	is_queued = false;					// true if a nurse is already attending this target
	destroy_on_finish = false;			// whether to destroy this target after finishing
}

function scr_target_find_next_target() {
	// find the next target for an NPC to go to
	
	var _target_count = instance_number(obj_npc_target);
	var _i;
	
	var _highest_priority = 9999;
	var _high_priority_targets = [];
	
	for (_i = 0; _i < _target_count; _i++) {
		// find the highest priority target
		
		var _current_target = instance_find(obj_npc_target, _i);
		
		// skip target if target is already attended
		if _current_target.is_queued {
			continue;
		}
		
		if _current_target.target_priority < _highest_priority {
			_highest_priority = _current_target.target_priority;
		}
	}
	
	// if all targets are attended at this point, return
	if _highest_priority == 9999 {
		return noone;
	}
	
	for (_i = 0; _i < _target_count; _i++) {
		// find all targets with the highest priority
		
		var _current_target = instance_find(obj_npc_target, _i);
		
		// skip target if target is already attended
		if _current_target.is_queued {
			continue;
		}
		
		if _current_target.target_priority == _highest_priority {
			array_insert(_high_priority_targets, array_length(_high_priority_targets), _current_target);
		}
	}
	
	// pick random target from the list
	var _random_target = _high_priority_targets[irandom(array_length(_high_priority_targets) - 1)];
	return _random_target;
}
