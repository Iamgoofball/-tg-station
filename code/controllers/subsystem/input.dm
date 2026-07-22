VERB_MANAGER_SUBSYSTEM_DEF(input)
	name = "Input"
	init_stage = INITSTAGE_EARLY
	ss_flags = SS_TICKER
	priority = FIRE_PRIORITY_INPUT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	use_default_stats = FALSE

	var/list/macro_set

	///running average of how many clicks inputted by a player the server processes every second. used for the subsystem stat entry
	var/clicks_per_second = 0
	///count of how many clicks onto atoms have elapsed before being cleared by fire(). used to average with clicks_per_second.
	var/current_clicks = 0
	///acts like clicks_per_second but only counts the clicks actually processed by SSinput itself while clicks_per_second counts all clicks
	var/delayed_clicks_per_second = 0
	///running average of how many movement iterations from player input the server processes every second. used for the subsystem stat entry
	var/movements_per_second = 0
	///running average of the amount of real time clicks take to truly execute after the command is originally sent to the server.
	///if a click isn't delayed at all then it counts as 0 deciseconds.
	var/average_click_delay = 0

#define INPUT_QUEUE_BATCH_TIME 10 // ticks (deciseconds) max processing per tick

/datum/controller/subsystem/verb_manager/input/Initialize()
	setup_default_macro_sets()

	initialized = TRUE

	refresh_client_macro_sets()

	return SS_INIT_SUCCESS

// This is for when macro sets are eventually datumized
/datum/controller/subsystem/verb_manager/input/proc/setup_default_macro_sets()
	macro_set = list(
		"Any" = "\"KeyDown \[\[*\]\] \[\[map.mouse-pos\]\] \[\[map.size\]\]\"",
		"Any+UP" = "\"KeyUp \[\[*\]\] \[\[map.mouse-pos\]\] \[\[map.size\]\]\"",
		"Back" = "\".winset \\\"input.text=\\\"\\\"\\\"\"",
		"Tab" = "\".winset \\\"input.focus=true?map.focus=true:input.focus=true\\\"\"",
		"Escape" = "Open-Escape-Menu",
	)

// Badmins just wanna have fun ♪
/datum/controller/subsystem/verb_manager/input/proc/refresh_client_macro_sets()
	var/list/clients = GLOB.clients
	for(var/i in 1 to clients.len)
		var/client/user = clients[i]
		user.set_macros()

/datum/controller/subsystem/verb_manager/input/can_queue_verb(datum/callback/verb_callback/incoming_callback, control)
	//make sure the incoming verb is actually something we specifically want to handle
	if(control != SKIN_MAPWINDOW_MAP)
		return FALSE

	if(average_click_delay > MAXIMUM_CLICK_LATENCY || !..())
		current_clicks++
		average_click_delay = MC_AVG_FAST_UP_SLOW_DOWN(average_click_delay, 0)
		return FALSE

	return TRUE

///stupid workaround for byond not recognizing the /atom/Click typepath for the queued click callbacks
/atom/proc/_Click(location, control, params)
	if(usr)
		Click(location, control, params)

/datum/controller/subsystem/verb_manager/input/fire()
	..()

	var/moves_this_run = 0
	for(var/mob/user in GLOB.keyloop_list)
		moves_this_run += user.focus?.keyLoop(user.client)//only increments if a player moves due to their own input

	movements_per_second = MC_AVG_SECONDS(movements_per_second, moves_this_run, wait TICKS)

/datum/controller/subsystem/verb_manager/input/run_verb_queue()
	// Safety: process in batches with timeout and exception isolation to prevent deadlocks
	#define INPUT_QUEUE_BATCH_TIME 10 // ticks (deciseconds)

	var/deferred_clicks_this_run = 0
	var/start_time = world.time
	var/index = 1
	var/queue_len = length(verb_queue)

	while(index <= queue_len)
		var/datum/callback/verb_callback/queued_click = verb_queue[index]
		if(!istype(queued_click))
			stack_trace("non /datum/callback/verb_callback instance inside SSinput's verb_queue!")
		else
			// Update click delay metric before invocation
			average_click_delay = MC_AVG_FAST_UP_SLOW_DOWN(average_click_delay, TICKS2DS((DS2TICKS(world.time) - queued_click.creation_time)))
			// Execute with exception isolation
			try
				queued_click.InvokeAsync()
				current_clicks++
				deferred_clicks_this_run++
			catch(var/exception/e)
				// Log error and continue; prevents a single bad callback from halting the queue
				log_error("SSinput callback error: [e] - Callback: [queued_click]")
				// Attempt to notify admins without throwing further errors
				if(isnull(GLOB) || !GLOB) // safety, though GLOB always exists
					message_admins("SSinput callback error: [e] in [queued_click]")
			// Check if we've exceeded the batch time budget; if so, stop processing and leave remaining items for next tick
			if(world.time - start_time >= INPUT_QUEUE_BATCH_TIME)
				index++ // advance so we know where we stopped
				break
		index++

	// Remove only the callbacks we processed (index-1 items)
	if(index > 1)
		verb_queue.Cut(1, index)

	clicks_per_second = MC_AVG_SECONDS(clicks_per_second, current_clicks, wait SECONDS)
	delayed_clicks_per_second = MC_AVG_SECONDS(delayed_clicks_per_second, deferred_clicks_this_run, wait SECONDS)
	current_clicks = 0

/datum/controller/subsystem/verb_manager/input/stat_entry(msg)
	msg = "\n  M/S:[round(movements_per_second,0.01)] | C/S:[round(clicks_per_second,0.01)] ([round(delayed_clicks_per_second,0.01)] | CD: [round(average_click_delay / (1 SECONDS),0.01)])"
	return ..()
