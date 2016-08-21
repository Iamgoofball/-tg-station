//TODO
// Admin button to override with your own
// Sabotage objective for tators
// Multiple goals with less impact but more department focused

/datum/station_goal
	var/name = "Generic Goal"
	var/weight = 1 //In case of multiple goals later.
	var/required_crew = 10
	var/gamemode_blacklist = list()

/datum/station_goal/proc/send_report()
	priority_announce("Priority nanotrasen directive recieved.", "Incoming Priority Message", 'sound/AI/commandreport.ogg')
	print_command_report(get_report(),"Nanotrasen Directive [pick(phonetic_alphabet)] \Roman[rand(1,50)]")
	on_report()

/datum/station_goal/proc/on_report()
	//Additional unlocks/changes go here
	return

/datum/station_goal/proc/get_report()
	return "Goal instructions go here"

/datum/station_goal/proc/check_completion()
	return FALSE

/datum/station_goal/proc/print_result()
	if(check_completion())
		world << "<b>Station Goal</b> : [name] :  <span class='greenannounce'>Completed!</span>"
	else
		world << "<b>Station Goal</b> : [name] : <span class='boldannounce'>Failed!</span>"

/*

//Crew has to create alien intelligence detector
// Requires a lot of minerals
// Dish requires a lot of power
// Needs five? AI's for decoding purposes
/datum/station_goal/seti
	name = "SETI Project"

//Crew Sweep
//Blood samples and special scans of amount of people on roundstart manifest.
//Should keep sec busy.
//Maybe after completion you'll get some ling detecting gear or some station wide DNA scan ?

*/