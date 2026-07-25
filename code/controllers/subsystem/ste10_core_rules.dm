/**
 * # Nova Sector 10 Core Rules — Community Standards
 *
 * This module codifies the Host-mandated 10 Core Rules (CR1-CR10) that govern
 * player conduct, server policy, and the social contract on Nova Sector.
 *
 * These are COMMUNITY STANDARDS, not code standards. They define how players
 * interact with each other, the setting, and Staff. Each rule is backed by
 * the Host and enforced by the moderation team.
 *
 * Source: Issue #224 (Host-mandated community standards, verbatim from issue body)
 *
 * Each rule is structured as a datum with:
 * - A unique identifier (CR1 through CR10)
 * - The full rule description as written in the issue
 * - Sub-rules that expand on specific expectations
 * - Display and lookup procs for in-game rule reference
 *
 * Also available as a human-readable markdown document: docs/CORE_RULES.md
 */

/// Master lookup table mapping rule numbers to their datums.
/// Use this for runtime rule display, enforcement hooks, and ahelp integration.
GLOBAL_LIST_INIT(ste10_core_rules, list(
	"CR1" = /datum/ste_rule/social_contract,
	"CR2" = /datum/ste_rule/vibe_check,
	"CR3" = /datum/ste_rule/setting_immersion,
	"CR4" = /datum/ste_rule/separation_of_identity,
	"CR5" = /datum/ste_rule/shift_integrity,
	"CR6" = /datum/ste_rule/style_points,
	"CR7" = /datum/ste_rule/consent_and_agency,
	"CR8" = /datum/ste_rule/antagonistic_conduct,
	"CR9" = /datum/ste_rule/station_infrastructure,
	"CR10" = /datum/ste_rule/rule_of_cool,
))

// ─────────────────────────────────────────────────────────────────────────────
// Rule Definitions — the Host-mandated community standards verbatim.
// ─────────────────────────────────────────────────────────────────────────────

/// CR1: The Social Contract
/// Conduct yourself with the maturity expected of an 18+ server.
/// Take the environment seriously. Follow Staff instructions and rulings.
/// Seek permission, not forgiveness. Self-report to Staff if you feel you
/// made a mistake. You are responsible for knowing the rules.
/// Ignorance is not an excuse.
#define STE_CR1_TITLE "CR1: The Social Contract"
#define STE_CR1_BODY "Conduct yourself with the maturity expected of an 18+ server. Take the environment seriously. Follow Staff instructions and rulings. Seek permission, not forgiveness. Self-report to Staff if you feel you made a mistake. You are responsible for knowing the rules. Ignorance is not an excuse."

#define STE_CR1_1 "Be Proactively Honest — Do not lie, omit context, or misrepresent facts in official channels. Provide all relevant information immediately."
#define STE_CR1_2 "If You See Something, Say Something — Please report perceived rule-breaks as they occur. While you may finish an active scene or moment before providing full details, you must not use this delay to escalate or seek retribution. Once a ticket is pending, all conflict with the accused parties must cease immediately. If you disagree with a ruling, remain civil and make a Staff Report ticket on Discord."
#define STE_CR1_3 "The Tap Out Rule — Your OOC consent to involvement in targeted content from another Crewmate, including any erotic content directed at you, may be retracted at any time, for any reason, and must be immediately respected by those involved. Using Local-OOC, state you are \"Invoking the Tap Out Rule\" or similar, disengage or ignore them, and ensure your own actions don't hinder their round in turn. If either party fails to comply, immediately Admin Help. This rule protects you from unpleasant interactions being forced on you, it is not a shield against the IC consequences of your own actions, nor does it override ERP-G-4's on-station exposure risks."
#define STE_CR1_4 "Leave Real History in the Past — Do not reference real political figures, governments, legislation, wars, or historical events that remain a source of active controversy or heavy discussion or debate to this day. Our Setting is 540 years in the future and these events are ancient history to your character. If you wouldn't expect your character to have a strong personal stake in something that happened in centuries past, do not bring it into the game."
#define STE_CR1_5 "Maintain Separation of Self and Character — Keep personal struggles out of roleplay. We recognize that life can be difficult and we genuinely care about our players' wellbeing, but your characters should not be a vehicle for real-life distress. We take this seriously not to punish people who are struggling, but to make sure the game doesn't become a substitute for real support, putting unfair emotional weight on other players. If you are going through something hard, please reach out to a trusted person or support resource."
#define STE_CR1_6 "Anguish With Intent — If you wish to explore your character's mental health as a subject for roleplay such as through psychology, mental breakdowns, or ongoing story arcs, it must be done with immersion in mind and escalated in a realistic way. Mental health topics should be used to elevate roleplay for all players, not used to excuse characters' bad behavior. Treat your character's mental health journey seriously to the best of your ability. If your character's arc appears to draw directly on disclosed real-life struggles rather than fictional characterization, Staff may intercede."
#define STE_CR1_7 "Suicide and Self-Harm Content Is Tightly Restricted — Intentional suicide as a resolved IC outcome is prohibited outside of the Die a Glorious Death antagonist objective. Discussion of suicide or self-harm must be kept strictly to use of the Subtler Verb and requires LOOC consent from everyone involved in the scene."
#define STE_CR1_8 "No Meta-Gaming — Information gained outside of IC experience in the current round is Metaknowledge. Using this information for an IC advantage is Metagaming and is prohibited. Playing with friends is welcome."

/// CR2: The Vibe Check
/// Carry yourself in good faith. Play and behave altruistically for the benefit
/// of everyone. You don't have to respect the character, but you must respect
/// the writer and the larger game environment.
#define STE_CR2_TITLE "CR2: The Vibe Check"
#define STE_CR2_BODY "Carry yourself in good faith. Play and behave altruistically for the benefit of everyone. You don't have to respect the character, but you must respect the writer and the larger game environment."

#define STE_CR2_1 "Safe Zones Must Be Respected — The Arrival Shuttle and Arrivals itself, the Escape Shuttle, the Interlink, and Ghost Cafés are Safe Zones. Conflict should not be instigated in or brought to these areas."
#define STE_CR2_2 "End of Round Grief and the Curtain Call — IC Expectations are ended when the Title Card / Credits / Shift Recap popup displays or becomes available. As we are actors, when the shift is over, so is our acting. Feel free to address each other as participants in a stageplay on an OOC level after the round ends. You are encouraged to maintain your character and complete a scene if you wish, but there is not an expectation to resolve any standing conflict or narrative at the title card. Remember the expectations of Safe Zones. Intentional griefing or continuation of mechanics with non-reciprocating parties is still considered EORG. Blowing up the Station, delaminating the Supermatter, or any other similar plans need to be cleared by Admin Help prior to the Title Card / Credits."
#define STE_CR2_3 "Respect Unresponsive Players — Characters not reacting to their environment are considered to have Space Sleeping Disorder. Do not touch or interfere with SSD players except to save them from immediate danger, or to relocate them to cryogenics after 30 minutes have passed, which you may do yourself if you wish, unless the character is a known suspect or actively wanted by Security, in which case Staff should be notified instead. If a Command or Security role-holder goes SSD, report it to Staff as these roles carry outsized narrative weight and shouldn't sit vacant unnoticed."
#define STE_CR2_4 "Don't Be Anti-Roleplay — Do not head to cryogenics or disconnect to evade IC consequences."
#define STE_CR2_5 "Mind Your Mouth — Slurs and hate speech that are directed at non-consenting parties are not welcome on Nova Sector. We understand that some players reclaim language as part of their identity, that is yours to own and not ours to police. However, the moment that language is turned outward at another person, it becomes our business. In-universe slurs against fictional species are fine for flavor, but must never be a vehicle or genuine disguise for equivalent real-world bigotry. If something said to you makes you uncomfortable, invoke the Tap Out Rule in Local-OOC. Real world racial epithets or direct fictional exchanges for those terms, when directed at another person rather than reclaimed self-reference, will result in administrative action."
#define STE_CR2_6 "Real Lives Are Valuable — Outright telling someone to kill themselves in any IC or OOC channel will result in administrative action. This is the difference between 'walk yourself out an airlock' and 'kill yourself'."
#define STE_CR2_7 "Don't Be An Agitator — Unwelcome harassment, targeted rumor-spreading, or OOC fear-mongering against individuals or groups is prohibited. Do not organize as a group against an individual."

/// CR3: Setting Immersion and Safety
/// Play a setting excusable adult Original Character with personality and
/// knowledge that respects our Lore, Narrative Setting, and your current Role.
#define STE_CR3_TITLE "CR3: Setting Immersion and Safety"
#define STE_CR3_BODY "Play a setting excusable adult Original Character with personality and knowledge that respects our Lore, Narrative Setting, and your current Role."

#define STE_CR3_1 "Use English — Keep primarily to English and only in the Latin alphabet. You may use transliterated or loan words from other languages as additive spice and character gimmick. If confronted or misunderstood, clarify yourself ICly. Do not circumvent our rules with this allowance."
#define STE_CR3_2 "No Netspeak — (lol, kek, chudling, 67, etc.) in IC speech, though it is permitted by PDA. Bitrunners that are on the Manifest, TTS Device users, and everyone within or spawning from a Bitdomain are excluded from this, assuming they remain high effort about it. This exemption never extends to 1337speak, which remains banned for all characters without exception."
#define STE_CR3_3 "Respawning Maintains the Story — Respawning as the same character, as the same job or as an assistant, is permitted if you left the round by cryogenics and would like to rejoin. Do not rejoin as the same or as a similar or related character if you died."
#define STE_CR3_4 "Post Mortality Blackout — In the likely event of your death or destruction, if you are revived, you retain no knowledge of the events preceding or individuals involved in your demise."
#define STE_CR3_5 "Respect Per-Shift Narrative Blackout — Shifts are loosely canon. You may remember interactions and events, but you must not recall specific names or faces tied to antagonistic actions or roles. Blackout can only be waived per shift by the person protected by the blackout. You can choose not to remember your involvement, even if you are named, and the Tap Out Rule can be invoked in this context. Do not target or treat a player differently IC due to OOC disagreements or events from previous rounds. Crew are not allowed to establish precedence or apply expectations for future rounds, such as stating that something must always be done a particular way. Keep the slate clean every shift."

/// CR4: You, Your Character, and Separation of Identity
/// Maintain a strict separation between your character and yourself.
/// Your character is a narrative tool. Do not allow OOC opinions, conflicts,
/// or personal moods to dictate their actions in a way that breaks immersion.
#define STE_CR4_TITLE "CR4: You, Your Character, and Separation of Identity"
#define STE_CR4_BODY "Maintain a strict separation between your character and yourself. Your character is a narrative tool. Do not allow OOC opinions, conflicts, or personal moods to dictate their actions in a way that breaks immersion. Set limitations for what your Character knows and can accomplish. Be prepared to justify your Character's actions and knowledge. No one is perfect and all knowing, and your Character shouldn't be either."

#define STE_CR4_1 "Play the Job That You Have — We have limited tolerance for characters that Departmentally job-hop across shifts. Be prepared to explain to the Crew and Staff why your Chief Engineer understands advanced surgery and organic chemistry enough to be a Chief Medical Officer too."
#define STE_CR4_2 "No Real Life Characters — You cannot play or recreate a character which resembles real life people, even for fun."
#define STE_CR4_3 "No Joke Characters In IC Spaces — You may not play jokey or meme characters."
#define STE_CR4_4 "No Stolen IP — You may not copy characters from pre-existing media. Adapted concepts are okay."
#define STE_CR4_5 "Take a Deep Breath — If Staff believe that you are bleeding harmful or combative emotions from yourself into your gameplay, regardless if you believe that you are, Staff may intercede."

/// CR5: Shift Integrity and Pacing
/// Your actions must be proportional to the situation. Escalate with effort.
/// Use words, emotes, and non-lethal conflict before resorting to violence.
/// Murder or grievous harm in direct response to minor insults or petty theft
/// is prohibited.
#define STE_CR5_TITLE "CR5: Shift Integrity and Pacing"
#define STE_CR5_BODY "Your actions must be proportional to the situation. Escalate with effort. Use words, emotes, and non-lethal conflict before resorting to violence. Murder or grievous harm in direct response to minor insults or petty theft is prohibited."

#define STE_CR5_1 "Maintain the Pace of the Plot — Do not skip narrative plot points for immediate satisfaction. Respect the buildup of a scene. If you self insert into a narrative that you were not previously a part of, do not detract from it by doing so."
#define STE_CR5_2 "Who Can Validhunt — Only Security and Command are authorized to actively hunt antagonists. This restriction lifts under any of the following: Red Alert, an active Crew Militia, or a specifically declared Station Threat that is otherwise not listed on Antagonist Policy."
#define STE_CR5_3 "Red Alert Escalation Freeze — Red Alert acts as an OOC freeze on new, unrelated antagonist actions. If you are aware that you were not the cause of the alert and are not part of the crew-wide response to the actual triggering threat, you must lay low and avoid starting further chaotic escalation of your own. This freeze applies to Antagonist and Self-Antagonism actions specifically. Crew Militia conduct is governed separately under Conflict Opt-Ins."
#define STE_CR5_4 "Low-Pop Exemptions — If the population is low, a Department is decimated, or there are other extenuating circumstances, and it would not be considered powergaming, you may perform tasks outside of your Job for the good of the narrative flow and the general health of being able to play the game. If for whatever reason the Station is unable to establish power, Admin Help for assistance."
#define STE_CR5_5 "Respect Evidence and MacGuffins — Do not destroy or hide items essential to an ongoing narrative for your own benefit; this includes excessive measures to cover your tracks and prevent all forensic efforts."

/// CR6: Style Points — Powergaming, Scene Integrity, and Honor Amongst Gamers
/// Your use of game knowledge, equipment, and Departmental access must primarily
/// benefit the story. We provide greater mechanical leeway to players who
/// demonstrate high-effort roleplay (immersive dialogue, custom emotes, and
/// depth). This principle informs Staff's judgment calls in ambiguous or
/// borderline situations. It does not exempt a player from any Core Rule or
/// ERP rule that has been clearly broken.
#define STE_CR6_TITLE "CR6: Style Points — Powergaming, Scene Integrity, and Honor Amongst Gamers"
#define STE_CR6_BODY "Your use of game knowledge, equipment, and Departmental access must primarily benefit the story. We provide greater mechanical leeway to players who demonstrate high-effort roleplay (immersive dialogue, custom emotes, and depth). This principle informs Staff's judgment calls in ambiguous or borderline situations. It does not exempt a player from any Core Rule or ERP rule that has been clearly broken. Act in Moderation, Game Respectfully. If you have to question if something may be too much, it is likely too much."

#define STE_CR6_1 "No Fortnite In Roleplay States — Do not manipulate the environment to gain a tactical advantage while a non-combat scene is in progress. Moving furniture, welding doors, or positioning yourself \"optimally\" during roleplay without a Combat Indicator is considered Bad Faith Powergaming. The other party may, at their discretion, treat actions like these as starting mechanics, but must still engage Combat Indicator before responding with force. Don't cry if you get shot or stabbed shortly after."
#define STE_CR6_2 "Respect The Awkwardness of Roleplay in an Action Game — SS13 has the capability to be a fast paced experience, and long-form roleplay is usually not fast paced. If you do not respect the integrity of a scene and its participants, you are acting in bad faith. This applies heavily to Security and Command, as their priority is to facilitate the round's narrative and not to win every encounter through mechanical optimization."
#define STE_CR6_3 "Give Antagonism a Chance — Give people causing conflict the opportunity to be entertaining. Turn a blind eye if it allows a scene to develop or a situation to worsen. A dead rat does not run or squeak, do not spoil your own fun."
#define STE_CR6_4 "No Departmental Overpreparedness — Do not excessively preemptively prepare your Department in a way which drastically negates the need for interaction with other Departments."

/// CR7: Consent, Agency, and Narrative Sovereignty
/// Respect the narrative desires and role responsibilities of others.
/// Your presence does not entitle you to involvement in someone else's scene.
/// Allow others the space to perform the roles they signed up for.
#define STE_CR7_TITLE "CR7: Consent, Agency, and Narrative Sovereignty"
#define STE_CR7_BODY "Respect the narrative desires and role responsibilities of others. Your presence does not entitle you to involvement in someone else's scene. Allow others the space to perform the roles they signed up for."

#define STE_CR7_1 "Transform and Convert with Consent — You must acquire clear OOC Consent to intentionally transform, convert (such as borging, mechanical hypnosis, etc), or alter the permanent physical appearance of a Character, or to convert them to Antagonism, regardless of their Conflict Opt or Objective status. Medical and Robotics may perform standard organic revivals without additional consent. Borging or any other transformative revival methods still requires consent. Temporarily placing a victim's brain into an MMI is always an acceptable method of communicating to establish consent."
#define STE_CR7_2 "Respect Conflict Opt — If a conflict results in a death, and the dead is not Conflict Opt — Expendable, then the body must remain locatable and recoverable by their group or the crew. Do not hide or space bodies. If this is not feasible, Admin Help for guidance. Yes, it is expected that if you beat someone to death that you will then throw or drag their crumpled body back to an easily viewable location of their Group, or ensure their sensors are on when you abandon their body."

/// CR8: Antagonistic Conduct, Optics, Collateral Damage, and the Narrative Vacuum
/// All Crew are bound by Antagonist Policy, which covers actions taken while
/// playing as a designated Antagonist. Do not fabricate or imitate true
/// antagonist status, gear, or objectives (e.g. claiming an uplink, a datum,
/// or Syndicate affiliation) without Staff allowance.
#define STE_CR8_TITLE "CR8: Antagonistic Conduct, Optics, Collateral Damage, and the Narrative Vacuum"
#define STE_CR8_BODY "All Crew are bound by Antagonist Policy, which covers actions taken while playing as a designated Antagonist. Do not fabricate or imitate true antagonist status, gear, or objectives (e.g. claiming an uplink, a datum, or Syndicate affiliation) without Staff allowance. Self-directed antagonistic conduct is separately governed under Self Antagonism."

#define STE_CR8_1 "Antagonism Defined — Any action that violates Corporate Regulations, causes lasting harm without consent, or is otherwise a significant, deliberate departure from lawful crew conduct undertaken to serve a criminal or disruptive narrative is considered Antagonism. Ordinary interpersonal friction, rudeness, or disagreement is not Antagonism on its own."
#define STE_CR8_2 "The Narrative Vacuum — The shift story is a collective experience witnessed by many points of view. Antagonism should be narratively founded, properly escalated, and witnessed or discoverable by others through context clues or mechanics like forensics."
#define STE_CR8_3 "Self Antagonism — Heavy antagonistic action committed by non-antagonists requires strong narrative justification and prior escalation. The more disruptive your self-antagonism, the more that Staff will scrutinize your roleplay quality and reasoning. If there is no established round specific reason for a crime to occur, it should not happen. \"It's what my character would do!\" is not a substitute for active, in-shift escalation, particularly sudden escalation to violence."

/// CR9: Station Infrastructure and Atmospheric Weapons
/// Damages to the Station must be escalated and founded narratively.
#define STE_CR9_TITLE "CR9: Station Infrastructure and Atmospheric Weapons"
#define STE_CR9_BODY "Damages to the Station must be escalated and founded narratively."

#define STE_CR9_1 "Vital Infrastructure — All SMES / Power Storage Units (not APCs), any major source of Electricity, Atmospherics Department, Atmospheric Projects (HFR, Turbine), and Distribution (Station Air and Waste, except for endpoints like vents and scrubbers) are protected. This protects the fixed infrastructure itself, not portable atmospheric equipment such as canisters used as improvised weapons under the rules below."
#define STE_CR9_2 "Fire as a Weapon and Plasma Flooding — Application of atmospheric mechanics which utilize fire as a primary weapon, such as canister plasma floods and burns, are prohibited. Flamethrowers are allowed."
#define STE_CR9_3 "Gas Weapons and Flooding — Only a single, unshielded, room-temperature canister of non-flammable gas (never exceeding 5000 mols) may be used per instance. It is good practice to inform Staff by Admin Help before doing so."
#define STE_CR9_4 "Collateral Damage Considerations — If you are using indiscriminate tools of violence, like explosives, you should do your best to avoid impacting Crew with Conflict-Opt Passive."
#define STE_CR9_5 "Simple Mob Stupidity — If you find yourself possessing a simple mob such a mold mob, maneater, regal rat, spider, or anything similar, your destruction should be proximal to your territory and should not leverage your game knowledge deeply."

/// CR10: The Rule of Cool
/// Staff may invoke "The Rule of Cool" to override gameplay or narrative
/// Core Rules. This functions as administrative jury nullification.
#define STE_CR10_TITLE "CR10: The Rule of Cool"
#define STE_CR10_BODY "Staff may invoke \"The Rule of Cool\" to override gameplay or narrative Core Rules. This functions as administrative jury nullification for our Rules. This discretion cannot be used to bypass CR1 or CR2, personal consent style rules, or the Legal Access and Age Requirements. Invoking this rule requires approval from the most senior Staff present. Staff must explicitly notify the involved players that a rule is being waived for that specific instance. Do not play with the expectation that staff will invoke this rule in your favor."

// ─────────────────────────────────────────────────────────────────────────────
// Rule Datum Definitions
// ─────────────────────────────────────────────────────────────────────────────

/// Base datum for all 10 Core Rules.
/// Each rule subtype holds the full text of a community standard and its
/// sub-rules, accessible for in-game display, ahelp integration, and
/// automated rule citation.
/datum/ste_rule
	/// The rule identifier (CR1 through CR10)
	var/rule_id = ""
	/// Short display title of the rule
	var/rule_title = ""
	/// The main body text of the rule
	var/rule_body = ""
	/// List of sub-rule texts associated with this rule
	var/list/sub_rules = list()

/// Returns the full formatted text of this rule, including all sub-rules.
/datum/ste_rule/proc/get_full_text()
	var/text = "[rule_title]\n\n[rule_body]"
	for (var/sub_rule in sub_rules)
		text += "\n    [sub_rule]"
	return text

/// Returns a compact one-line summary of this rule.
/datum/ste_rule/proc/get_summary()
	return "[rule_id]: [rule_title]"

/// Returns all sub-rules as a flat list of strings.
/datum/ste_rule/proc/get_sub_rules()
	return sub_rules.Copy()

// ─────────────────────────────────────────────────────────────────────────────
// CR1: The Social Contract
// ─────────────────────────────────────────────────────────────────────────────

/datum/ste_rule/social_contract
	rule_id = "CR1"
	rule_title = STE_CR1_TITLE
	rule_body = STE_CR1_BODY
	sub_rules = list(
		STE_CR1_1,
		STE_CR1_2,
		STE_CR1_3,
		STE_CR1_4,
		STE_CR1_5,
		STE_CR1_6,
		STE_CR1_7,
		STE_CR1_8,
	)

// ─────────────────────────────────────────────────────────────────────────────
// CR2: The Vibe Check
// ─────────────────────────────────────────────────────────────────────────────

/datum/ste_rule/vibe_check
	rule_id = "CR2"
	rule_title = STE_CR2_TITLE
	rule_body = STE_CR2_BODY
	sub_rules = list(
		STE_CR2_1,
		STE_CR2_2,
		STE_CR2_3,
		STE_CR2_4,
		STE_CR2_5,
		STE_CR2_6,
		STE_CR2_7,
	)

// ─────────────────────────────────────────────────────────────────────────────
// CR3: Setting Immersion and Safety
// ─────────────────────────────────────────────────────────────────────────────

/datum/ste_rule/setting_immersion
	rule_id = "CR3"
	rule_title = STE_CR3_TITLE
	rule_body = STE_CR3_BODY
	sub_rules = list(
		STE_CR3_1,
		STE_CR3_2,
		STE_CR3_3,
		STE_CR3_4,
		STE_CR3_5,
	)

// ─────────────────────────────────────────────────────────────────────────────
// CR4: You, Your Character, and Separation of Identity
// ─────────────────────────────────────────────────────────────────────────────

/datum/ste_rule/separation_of_identity
	rule_id = "CR4"
	rule_title = STE_CR4_TITLE
	rule_body = STE_CR4_BODY
	sub_rules = list(
		STE_CR4_1,
		STE_CR4_2,
		STE_CR4_3,
		STE_CR4_4,
		STE_CR4_5,
	)

// ─────────────────────────────────────────────────────────────────────────────
// CR5: Shift Integrity and Pacing
// ─────────────────────────────────────────────────────────────────────────────

/datum/ste_rule/shift_integrity
	rule_id = "CR5"
	rule_title = STE_CR5_TITLE
	rule_body = STE_CR5_BODY
	sub_rules = list(
		STE_CR5_1,
		STE_CR5_2,
		STE_CR5_3,
		STE_CR5_4,
		STE_CR5_5,
	)

// ─────────────────────────────────────────────────────────────────────────────
// CR6: Style Points — Powergaming, Scene Integrity, and Honor Amongst Gamers
// ─────────────────────────────────────────────────────────────────────────────

/datum/ste_rule/style_points
	rule_id = "CR6"
	rule_title = STE_CR6_TITLE
	rule_body = STE_CR6_BODY
	sub_rules = list(
		STE_CR6_1,
		STE_CR6_2,
		STE_CR6_3,
		STE_CR6_4,
	)

// ─────────────────────────────────────────────────────────────────────────────
// CR7: Consent, Agency, and Narrative Sovereignty
// ─────────────────────────────────────────────────────────────────────────────

/datum/ste_rule/consent_and_agency
	rule_id = "CR7"
	rule_title = STE_CR7_TITLE
	rule_body = STE_CR7_BODY
	sub_rules = list(
		STE_CR7_1,
		STE_CR7_2,
	)

// ─────────────────────────────────────────────────────────────────────────────
// CR8: Antagonistic Conduct, Optics, Collateral Damage, and the Narrative Vacuum
// ─────────────────────────────────────────────────────────────────────────────

/datum/ste_rule/antagonistic_conduct
	rule_id = "CR8"
	rule_title = STE_CR8_TITLE
	rule_body = STE_CR8_BODY
	sub_rules = list(
		STE_CR8_1,
		STE_CR8_2,
		STE_CR8_3,
	)

// ─────────────────────────────────────────────────────────────────────────────
// CR9: Station Infrastructure and Atmospheric Weapons
// ─────────────────────────────────────────────────────────────────────────────

/datum/ste_rule/station_infrastructure
	rule_id = "CR9"
	rule_title = STE_CR9_TITLE
	rule_body = STE_CR9_BODY
	sub_rules = list(
		STE_CR9_1,
		STE_CR9_2,
		STE_CR9_3,
		STE_CR9_4,
		STE_CR9_5,
	)

// ─────────────────────────────────────────────────────────────────────────────
// CR10: The Rule of Cool
// ─────────────────────────────────────────────────────────────────────────────

/datum/ste_rule/rule_of_cool
	rule_id = "CR10"
	rule_title = STE_CR10_TITLE
	rule_body = STE_CR10_BODY
	sub_rules = list()

// ─────────────────────────────────────────────────────────────────────────────
// Rule Display and Lookup Procs
// ─────────────────────────────────────────────────────────────────────────────

/// Returns a flat list of all rule summaries for quick browsing.
/proc/get_all_core_rule_summaries()
	var/list/summaries = list()
	for (var/rule_key in GLOB.ste10_core_rules)
		var/datum/ste_rule/rule = GLOB.ste10_core_rules[rule_key]
		summaries += rule.get_summary()
	return summaries

/// Looks up a single rule by its identifier (e.g. "CR1") and returns its datum.
/// Returns null if no rule matches that identifier.
/proc/get_core_rule_by_id(rule_id)
	for (var/rule_key in GLOB.ste10_core_rules)
		var/datum/ste_rule/rule = GLOB.ste10_core_rules[rule_key]
		if (rule.rule_id == rule_id)
			return rule
	return null

/// Returns the full text of a rule by its CR number (1 through 10).
/// Returns an empty string if the number is out of range.
/proc/get_core_rule_text(rule_number)
	var/datum/ste_rule/rule = get_core_rule_by_id("CR[rule_number]")
	if (!rule)
		return ""
	return rule.get_full_text()

/// Displays all 10 Core Rules to a mob, formatted for chat output.
/// Use this for in-game rulebook items, ahelp auto-replies, and admin verbs.
/proc/display_ste10_rules(mob/user)
	to_chat(user, span_boldnotice("═══ Nova Sector 10 Core Rules ═══"))
	to_chat(user, "")
	for (var/rule_key in GLOB.ste10_core_rules)
		var/datum/ste_rule/rule = GLOB.ste10_core_rules[rule_key]
		to_chat(user, span_notice("[rule.rule_title]"))
		to_chat(user, span_info("[rule.rule_body]"))
		for (var/sub_rule in rule.sub_rules)
			to_chat(user, "    [sub_rule]")
		to_chat(user, "")
	to_chat(user, span_info("These rules are Host-mandated community standards."))
	to_chat(user, span_info("Use the 'Rules' verb or consult Staff for questions."))

/// Admin verb to display all 10 Core Rules in chat.
/client/verb/view_core_rules()
	set name = "View Core Rules"
	set category = "Admin"
	set desc = "Display the Nova Sector 10 Core Rules."

	display_ste10_rules(usr)

/// Admin verb to search rules by keyword.
/client/verb/search_core_rules()
	set name = "Search Core Rules"
	set category = "Admin"
	set desc = "Search the 10 Core Rules for a keyword."

	var/keyword = tgui_input_text(usr, "Enter keyword to search for in the Core Rules:", "Rule Search")
	if (!keyword)
		return

	var/found_any = FALSE
	for (var/rule_key in GLOB.ste10_core_rules)
		var/datum/ste_rule/rule = GLOB.ste10_core_rules[rule_key]
		var/full_text = rule.get_full_text()
		if (findtext(full_text, keyword))
			found_any = TRUE
			to_chat(usr, span_notice("[rule.rule_title]"))
			to_chat(usr, span_info("[rule.rule_body]"))

	if (!found_any)
		to_chat(usr, span_warning("No Core Rules matched '[keyword]'."))

/// Looks up a rule that contains the given keyword and returns its identifier.
/// Useful for automated ahelp responses and rule citations.
/proc/find_core_rule_citation(keyword)
	for (var/rule_key in GLOB.ste10_core_rules)
		var/datum/ste_rule/rule = GLOB.ste10_core_rules[rule_key]
		if (findtext(rule.get_full_text(), keyword))
			return rule.rule_id
	return null
