function scr_game_manager_init() {
	sprint_energy_max = 20;
	sprint_energy = sprint_energy_max;
	sprint_drain_rate = 0.1;
	sprint_reload_rate = 0.03;
	can_sprint = true;
	
	blood_level_max = 20;
	blood_level = blood_level_max;
	blood_drain_rate = 0.005;
	
	time = 0;
	time_increment = 60 * 4;
	
	hr = 0;
	mn = 0;
	hr_str = "00";
	mn_str = "00";
}

function scr_game_manager_update() {
	if !can_sprint {
		scr_game_manager_regain_sprinting();
	}
	
	scr_game_manager_update_blood_level();
	
	time++;
	
	if time >= time_increment {
		mn += 15;
		if mn == 60 {
			mn = 0;
			hr++;
			
			if hr == 12 {
				room_goto(rm_win);
			}
		}
		
		time = 0;
	}
	hr_str = hr < 10 ? "0" + string(hr) : string(hr);
	mn_str = mn < 10 ? "0" + string(mn) : string(mn);
}

function scr_game_manager_regain_sprinting() {
	sprint_energy += sprint_reload_rate;
	
	if sprint_energy >= sprint_energy_max {
		can_sprint = true;
		sprint_energy = sprint_energy_max;
	}
}

function scr_game_manager_update_blood_level() {
	blood_level -= blood_drain_rate;
	
	if blood_level <= 0 {
		blood_level = 0;
		room_goto(rm_gameover2)
	}
}

function scr_game_manager_game_over(_reason) {
	
}
