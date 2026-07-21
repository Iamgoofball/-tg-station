/obj/mob/living/carbon/human/security
    var/current_quest = null

    AssignDailyQuest()
        current_quest = quest_manager.GetDailyQuest()
        src << "You have been assigned a new daily quest: <<current_quest>>"

    CompleteQuest()
        if(quest_manager.CompleteDailyQuest(current_quest, usr))
            src << "Quest completed! You have been awarded <<quest_manager.daily_quests.quest_list[current_quest]["reward"]>> credits."
            current_quest = null
            AssignDailyQuest()
        else
            src << "Failed to complete quest."

    Update()
        . = original()
        quest_manager.UpdateDailyQuests()