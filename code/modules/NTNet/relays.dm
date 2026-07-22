///Checks whether NTNet is available by ensuring at least one relay exists and is operational.
/proc/find_functional_ntnet_relay()
	// Check all relays. If we have at least one working relay, ntos is up.
	for(var/obj/machinery/ntnet_relay/relays as anything in SSmachines.get_machines_by_type(/obj/machinery/ntnet_relay))
		if(!relays.is_operational)
			continue
		return TRUE
	return FALSE

/// Publishes a list packet from station machinery to every matching Wiremod NTNet receiver.
/proc/send_ntnet_data_package(list/data, encryption_key)
	if(!islist(data) || !find_functional_ntnet_relay())
		return FALSE
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_NTNET_DATA_SENT, list(
		"data" = data,
		"enc_key" = encryption_key,
		"port" = null,
	))
	return TRUE

/// A compact office terminal mapped beside every Network Engineer roundstart landmark.
/obj/machinery/network_operations_terminal
	name = "network operations terminal"
	desc = "A wall-mounted NTNet console cataloguing departmental machinery, airlocks, and wire-interface alerts. Its violet carrier trace is the Network Engineer's first line of warning."
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "processor"
	density = FALSE
	use_power = IDLE_POWER_USE
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION
	interaction_flags_machine = INTERACT_MACHINE_ALLOW_SILICON
	/// Fault addresses from the last assigned route. Repairing them and returning earns a small personal bonus.
	var/list/assigned_faults = list()
	/// Prevents repeatedly claiming an already-completed route.
	var/next_route_reward = 0

/// Adds the live endpoint count and audit instructions to the terminal's examination text.
/obj/machinery/network_operations_terminal/examine(mob/user)
	. = ..()
	. += span_notice("The endpoint directory reports [length(SSmachines.get_machines_by_type_and_subtypes(/obj/machinery))] registered machines; use a multitool to compile a station maintenance audit.")

/// Compiles a station-wide maintenance queue so the Network Engineer hath useful work even when no hostile carrier appeareth.
/obj/machinery/network_operations_terminal/proc/compile_network_audit(station_only = TRUE)
	var/list/alerts = list()
	var/endpoint_count = 0
	var/wire_endpoint_count = 0
	var/broken_count = 0
	var/unpowered_count = 0
	var/emp_count = 0
	var/open_panel_count = 0
	for(var/obj/machinery/machine as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery))
		if(!machine.ntnet_endpoint || (station_only && !is_station_level(machine.z)))
			continue
		endpoint_count++
		if(!isnull(machine.wires))
			wire_endpoint_count++
		var/fault
		if(machine.machine_stat & BROKEN)
			broken_count++
			fault = "hardware fault"
		else if(machine.machine_stat & EMPED)
			emp_count++
			fault = "firmware fault"
		else if(machine.machine_stat & NOPOWER)
			unpowered_count++
			fault = "power loss"
		if(machine.panel_open)
			open_panel_count++
			fault ||= "open maintenance panel"
		if(fault)
			alerts += list(list(
				"address" = machine.ntnet_address,
				"area" = get_area_name(machine, TRUE),
				"fault" = fault,
				"name" = machine.name,
			))
	return list(
		"alerts" = alerts,
		"broken" = broken_count,
		"emped" = emp_count,
		"endpoints" = endpoint_count,
		"open_panels" = open_panel_count,
		"unpowered" = unpowered_count,
		"wire_endpoints" = wire_endpoint_count,
	)

/// Runs a trained endpoint audit which turneth ordinary power, repair, and panel faults into a concrete patrol route.
/obj/machinery/network_operations_terminal/multitool_act(mob/living/user, obj/item/tool)
	if(!HAS_TRAIT(user, TRAIT_NETWORK_DIAGNOSTICS))
		balloon_alert(user, "certification required")
		return ITEM_INTERACT_BLOCKING
	if(!is_operational)
		balloon_alert(user, "terminal offline")
		return ITEM_INTERACT_BLOCKING
	balloon_alert(user, "auditing endpoints...")
	if(!do_after(user, 5 SECONDS, target = src))
		return ITEM_INTERACT_BLOCKING
	var/list/audit = compile_network_audit()
	var/list/current_alerts = audit["alerts"]
	var/list/current_faults = list()
	for(var/list/current_alert as anything in current_alerts)
		current_faults[current_alert["address"]] = TRUE
	if(length(assigned_faults))
		var/resolved = 0
		for(var/address in assigned_faults)
			if(!current_faults[address])
				resolved++
		if(resolved && world.time >= next_route_reward)
			var/datum/bank_account/account = user.get_bank_account()
			if(account)
				var/reward = min(resolved * 15, 75)
				account.adjust_money(reward, "NTNet maintenance route completion")
				to_chat(user, span_green("[resolved] assigned endpoint fault[resolved == 1 ? "" : "s"] verified repaired. A [reward] credit maintenance bonus has been deposited."))
				next_route_reward = world.time + 10 MINUTES
	assigned_faults = current_faults
	to_chat(user, span_boldnotice("NTNet MAINTENANCE AUDIT"))
	to_chat(user, span_notice("[audit["endpoints"]] endpoints ([audit["wire_endpoints"]] wired): [audit["broken"]] hardware faults, [audit["emped"]] firmware faults, [audit["unpowered"]] power losses, and [audit["open_panels"]] open panels."))
	var/list/alerts = current_alerts
	if(!length(alerts))
		to_chat(user, span_green("All station endpoints report nominal status. No maintenance route is required."))
		return ITEM_INTERACT_SUCCESS
	var/alerts_shown = 0
	for(var/list/alert as anything in alerts)
		to_chat(user, span_warning("[alert["address"]] — [alert["name"]], [alert["area"]]: [alert["fault"]]."))
		if(++alerts_shown >= 5)
			break
	if(length(alerts) > alerts_shown)
		to_chat(user, span_notice("[length(alerts) - alerts_shown] additional alerts remain queued; rerun the audit after servicing this route."))
	return ITEM_INTERACT_SUCCESS

// Relays don't handle any actual communication. Global NTNet datum does that, relays only tell the datum if it should or shouldn't work.
/obj/machinery/ntnet_relay
	name = "NTNet Quantum Relay"
	desc = "A very complex router and transmitter capable of connecting electronic devices together. Looks fragile."
	use_power = ACTIVE_POWER_USE
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 10 //10kW, apropriate for machine that keeps massive cross-Zlevel wireless network operational. Used to be 20 but that actually drained the smes one round
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "bus"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/ntnet_relay

	///On / off status for the relay machine, toggleable by the user.
	var/relay_enabled = TRUE
	///(D)DoS-attack-related failure causing it not to be operational any longer.
	var/dos_failure = FALSE
	var/list/dos_sources = list() // Backwards reference for qdel() stuff
	var/uid
	var/static/gl_uid = 1

	// Denial of Service attack variables
	var/dos_overload = 0 // Amount of DoS "packets" in this relay's buffer
	var/dos_capacity = 500 // Amount of DoS "packets" in buffer required to crash the relay
	var/dos_dissipate = 0.5 // Amount of DoS "packets" dissipated over time.

/obj/machinery/ntnet_relay/Initialize(mapload)
	. = ..()
	uid = gl_uid++
	var/list/current_machines = SSmachines.get_machines_by_type(/obj/machinery/ntnet_relay)
	SSmodular_computers.add_log("New quantum relay activated. Current amount of linked relays: [current_machines.len]")

/obj/machinery/ntnet_relay/Destroy()
	. = ..()
	var/list/machines_left = SSmachines.get_machines_by_type(/obj/machinery/ntnet_relay)
	SSmodular_computers.add_log("Quantum relay connection severed. Current amount of linked relays: [machines_left.len]")
	for(var/datum/computer_file/program/ntnet_dos/D in dos_sources)
		D.target = null
		D.error = "Connection to quantum relay severed"

///Proc called to change the value of the `relay_enabled` variable and append behavior related to its change.
/obj/machinery/ntnet_relay/proc/set_relay_enabled(new_value)
	if(new_value == relay_enabled)
		return
	. = relay_enabled
	relay_enabled = new_value
	if(.) //Turned off
		set_is_operational(FALSE)
	else if(!dos_failure && !(machine_stat & (NOPOWER|BROKEN|MAINT))) //Turned on
		set_is_operational(TRUE)

///Proc called to change the value of the `dos_failure` variable and append behavior related to its change.
/obj/machinery/ntnet_relay/proc/set_dos_failure(new_value)
	if(new_value == dos_failure)
		return
	. = dos_failure
	dos_failure = new_value
	if(.) //Failure ended
		if(relay_enabled && !(machine_stat & (NOPOWER|BROKEN|MAINT)))
			set_is_operational(TRUE)
	else //Failure started
		set_is_operational(FALSE)

/obj/machinery/ntnet_relay/on_set_machine_stat(old_value)
	if(old_value & (NOPOWER|BROKEN|MAINT))
		if(relay_enabled && !dos_failure && !(machine_stat & (NOPOWER|BROKEN|MAINT))) //From off to on.
			set_is_operational(TRUE)
	else if(machine_stat & (NOPOWER|BROKEN|MAINT)) //From on to off.
		set_is_operational(FALSE)

/obj/machinery/ntnet_relay/update_icon_state()
	icon_state = "bus[is_operational ? null : "_off"]"
	return ..()

/obj/machinery/ntnet_relay/process(seconds_per_tick)
	update_use_power(is_operational ? ACTIVE_POWER_USE : IDLE_POWER_USE)

	update_appearance()

	if(dos_overload > 0)
		dos_overload = max(0, dos_overload - dos_dissipate * seconds_per_tick)

	// If DoS traffic exceeded capacity, crash.
	if((dos_overload > dos_capacity) && !dos_failure)
		set_dos_failure(TRUE)
		update_appearance()
		SSmodular_computers.add_log("Quantum relay switched from normal operation mode to overload recovery mode.")
	// If the DoS buffer reaches 0 again, restart.
	if((dos_overload == 0) && dos_failure)
		set_dos_failure(FALSE)
		update_appearance()
		SSmodular_computers.add_log("Quantum relay switched from overload recovery mode to normal operation mode.")
	return TRUE

/obj/machinery/ntnet_relay/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NtnetRelay")
		ui.open()

/obj/machinery/ntnet_relay/ui_data(mob/user)
	var/list/data = list()
	data["enabled"] = relay_enabled
	data["dos_capacity"] = dos_capacity
	data["dos_overload"] = dos_overload
	data["dos_crashed"] = dos_failure
	return data

/obj/machinery/ntnet_relay/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("restart")
			dos_overload = 0
			set_dos_failure(FALSE)
			update_appearance()
			SSmodular_computers.add_log("Quantum relay manually restarted from overload recovery mode to normal operation mode.")
			return TRUE
		if("toggle")
			set_relay_enabled(!relay_enabled)
			SSmodular_computers.add_log("Quantum relay manually [relay_enabled ? "enabled" : "disabled"].")
			update_appearance()
			return TRUE
