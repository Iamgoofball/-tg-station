/datum/language_modifier/owospeak
    name = "Owospeak"
    desc = "Applies uwu/owo speech patterns to the speaker. :3"

/datum/language_modifier/owospeak/proc/modify_speech(message)
    if(!message)
        return message

    // Replace 'r' and 'l' with 'w'
    message = replacetext(message, "r", "w")
    message = replacetext(message, "R", "W")
    message = replacetext(message, "l", "w")
    message = replacetext(message, "L", "W")

    // Replace 'th' with 'd' or 'f'
    message = replacetext(message, "th", "d")
    message = replacetext(message, "Th", "D")
    message = replacetext(message, "TH", "D")

    // Add random owo-isms
    var/static/list/suffixes = list(" :3", " uwu", " owo", " nya~", " rawr", " >w<", " ^w^", " meow")
    var/static/list/prefixes = list("uwu ", "nyaa ", "hewwo ", "hai ")

    if(prob(15))
        message += pick(suffixes)
    if(prob(10))
        message = pick(prefixes) + message

    return message
