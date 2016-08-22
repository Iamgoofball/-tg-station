var/list/the_law = list()
var/name_of_the_law = "Space Law"

// When setting a default punishment string, the minute to labor camp point ratio is 5:100, 5 minutes is 100 points.

/datum/space_law
	var/name = "Right To Empty Return"
	var/desc = "return"
	var/punishment = "Repoban"
	var/roundstart = 0

/datum/space_law/fuq
	name = "shit"
	desc = "ass"
	punishment = "1 Minute OR 20 Labor Camp Points"
	roundstart = 1

// The default laws

// Minor laws, a minute or 20 points

/datum/space_law/resisting_arrest
	name = "Resisting Arrest"
	desc = "To not cooperate with an officer who attempts a proper arrest."
	punishment = "1 Minute OR 20 Labor Camp Points"
	roundstart = 1

/datum/space_law/drug_possession
	name = "Drug Possession"
	desc = "To possess space drugs or other narcotics by unauthorised personnel."
	punishment = "1 Minute OR 20 Labor Camp Points"
	roundstart = 1

/datum/space_law/indecent_exposure
	name = "Indecent Exposure"
	desc = "To be intentionally and publicly unclothed."
	punishment = "1 Minute OR 20 Labor Camp Points"
	roundstart = 1

/datum/space_law/vandalism
	name = "Vandalism"
	desc = "To deliberately damage the station without malicious intent."
	punishment = "1 Minute OR 20 Labor Camp Points, multiplied by the level of damage caused."
	roundstart = 1

/datum/space_law/trespassing
	name = "Trespassing"
	desc = "To be in an area which a person does not have access to. This counts for general areas of the ship, and trespassing in restricted areas is a more serious crime."
	punishment = "1 Minute OR 20 Labor Camp Points"
	roundstart = 1

// Medium Crimes
// 2 minutes or 40 points at the labor camp

/datum/space_law/assault
	name = "Assault"
	desc = "To use physical force against someone without the apparent intent to kill them."
	punishment = "2 Minute OR 40 Labor Camp Points"
	roundstart = 1

/datum/space_law/pickpocketing
	name = "Pickpocketing"
	desc = "To steal items from another's person."
	punishment = "2 Minute OR 40 Labor Camp Points"
	roundstart = 1

/datum/space_law/narcotics_distribution
	name = "Narcotics Distribution"
	desc = "To distribute narcotics and other controlled substances."
	punishment = "2 Minute OR 40 Labor Camp Points"
	roundstart = 1

/datum/space_law/possession_of_a_weapon
	name = "Possession of a Weapon"
	desc = "To be in possession of a dangerous item that is not part of their job role."
	punishment = "2 Minute OR 40 Labor Camp Points"
	roundstart = 1

/datum/space_law/petty_theft
	name = "Petty Theft"
	desc = "To take items from areas one does not have access to or to take items belonging to others or the station as a whole."
	punishment = "2 Minute OR 40 Labor Camp Points"
	roundstart = 1

/datum/space_law/rioting
	name = "Rioting"
	desc = "To partake in an unauthorised and disruptive assembly of crewmen that refuse to disperse."
	punishment = "2 Minute OR 40 Labor Camp Points"
	roundstart = 1

/datum/space_law/creating_a_workplace_hazard
	name = "Creating a Workplace Hazard"
	desc = "To endanger the crew or station through negligent or irresponsible, but not deliberately malicious, actions."
	punishment = "2 Minute OR 40 Labor Camp Points"
	roundstart = 1

/datum/space_law/b_and_e
	name = "Breaking and Entering"
	desc = "Forced entry to areas where the subject does not have access to. This counts for general areas, and breaking into restricted areas is a more serious crime."
	punishment = "2 Minute OR 40 Labor Camp Points"
	roundstart = 1

/datum/space_law/insubordination
	name = "Insubordination"
	desc = "To disobey a lawful direct order from one's superior officer."
	punishment = "Demotion"
	roundstart = 1

// Major Crimes
// 5 minutes, or 100 points.

/datum/space_law/assault_weapon
	name = "Assault With a Deadly Weapon"
	desc = "To use physical force, through a deadly weapon, against someone without the apparent intent to kill them."
	punishment = "5 Minutes OR 100 Labor Camp Points"
	roundstart = 1

/datum/space_law/assault_officer
	name = "Assault of an Officer"
	desc = "To use physical force against a Department Head or member of Security without the apparent intent to kill them."
	punishment = "5 Minutes OR 100 Labor Camp Points"
	roundstart = 1

/datum/space_law/pickpocketing
	name = "Manslaughter"
	desc = "To unintentionally kill someone through negligent, but not malicious, actions.
	punishment = "5 Minutes OR 100 Labor Camp Points"
	roundstart = 1

/datum/space_law/possession_of_restricted_weapon
	name = "Possession of a Restricted Weapon"
	desc = "To be in possession of a restricted weapon without prior authorization, such as: Guns, Batons, Flashes, Grenades, etc."
	punishment = "5 Minutes OR 100 Labor Camp Points"
	roundstart = 1

/datum/space_law/possession_of_explosives
	name = "Possession of Explosives"
	desc = "To be in possession of an explosive device."
	punishment = "5 Minutes OR 100 Labor Camp Points"
	roundstart = 1

/datum/space_law/inciting_a_riot
	name = "Inciting a Riot"
	desc = "To attempt to stir the crew into a riot"
	punishment = "5 Minutes OR 100 Labor Camp Points"
	roundstart = 1

/datum/space_law/major_trespassing
	name = "Major Trespassing"
	desc = "Being in a restricted area without prior authorisation. This includes any Security Area, Command area (including EVA), the Engine Room, Atmos, or Toxins Research.
	punishment = "5 Minutes OR 100 Labor Camp Points"
	roundstart = 1

/datum/space_law/sabotage
	name = "Sabotage"
	desc = "To hinder the work of the crew or station through malicious actions."
	punishment = "5 Minutes OR 100 Labor Camp Points"
	roundstart = 1

/datum/space_law/b_and_e_restricted
	name = "B&E of a Restricted Area"
	desc = "This is breaking into any Security area, Command area (Bridge, EVA, Captains Quarters, Teleporter, etc.), the Engine Room, Atmos, or Toxins research."
	punishment = "5 Minutes OR 100 Labor Camp Points"
	roundstart = 1

/datum/space_law/dod
	name = "Dereliction of Duty"
	desc = "To willfully abandon an obligation that is critical to the station's continued operation."
	punishment = "Demotion"
	roundstart = 1

// Capital Crimes
// Permabrig, Permagulag, or Execution

/datum/space_law/murder
	name = "Murder"
	desc = "To maliciously kill someone."
	punishment = "Permabrig, Permagulag, or Execution"
	roundstart = 1

/datum/space_law/attempted_murder
	name = "Attempted Murder"
	desc = "To use physical force against a person until that person is in a critical state with the apparent intent to kill them."
	punishment = "Permabrig, Permagulag, or Execution"
	roundstart = 1

/datum/space_law/mutiny
	name = "Mutiny"
	desc = "To act individually, or as a group, to overthrow or subvert the established Chain of Command without lawful and legitimate cause."
	punishment = "Permabrig, Permagulag, or Execution"
	roundstart = 1

/datum/space_law/grand_sabotage //dad
	name = "Grand Sabotage" // flintstones???
	desc = "To engage in maliciously destructive actions, seriously threatening crew or station."
	punishment = "Permabrig, Permagulag, or Execution"
	roundstart = 1

/datum/space_law/grand_theft // its the
	name = "Grand Theft" // honk shack
	desc = "To steal items of high value or sensitive nature."
	punishment = "Permabrig, Permagulag, or Execution"
	roundstart = 1

/datum/space_law/enemy
	name = "Enemy of the Corporation"
	desc = "To act as, or knowingly aid, an enemy of Nanotrasen."
	punishment = "Permabrig, Permagulag, or Execution"
	roundstart = 1