/obj/announcement/manager
    NewDailyQuestAnnouncement(quest_name)
        world << "A new daily quest is available: <<quest_name>>"

    Update()
        . = original()
        var/new_quest = quest_manager.GetDailyQuest()
        if(new_quest != last_announced_quest)
            NewDailyQuestAnnouncement(new_quest)
            last_announced_quest = new_quest