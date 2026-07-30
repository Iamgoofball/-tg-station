// Vending machine stock - updated drink names
// Fourteen Loko replaces Thirteen Loko in all vending machine stock lists

/obj/machinery/vending/cola
	name = "Robust Softdrinks"
	product_ads = list("Refreshing!", "Ice cold!", "Try our new Fourteen Loko!")
	products = list(
		/obj/item/reagent_containers/food/drinks/canned/cola = 6,
		/obj/item/reagent_containers/food/drinks/canned/fourteen_loko = 3
	)
