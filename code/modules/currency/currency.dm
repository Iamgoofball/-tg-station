/obj/mob/living/carbon/human
    var/currency = 0

    AddCurrency(amount)
        currency += amount

    RemoveCurrency(amount)
        if(currency >= amount)
            currency -= amount
            return 1
        return 0