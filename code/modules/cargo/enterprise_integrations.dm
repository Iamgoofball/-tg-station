/// Builds no-network Shopify and CRM payloads for cargo enterprise integrations.
/datum/cargo_enterprise_integration

/// Builds a Shopify-style draft listing payload for a supply pack without making an external request.
/datum/cargo_enterprise_integration/proc/build_shopify_listing(datum/supply_pack/pack, pack_id, quantity = 1)
	if(!istype(pack))
		return list()

	var/listing_price = pack.cost
	if(!isnull(SSeconomy))
		listing_price = pack.get_cost()

	return list(
		"provider" = "shopify",
		"event" = "draft_listing",
		"sku" = "[pack_id]",
		"title" = pack.name,
		"description" = pack.desc || pack.name,
		"price" = listing_price,
		"currency" = MONEY_SYMBOL,
		"quantity" = max(1, quantity),
		"draft" = TRUE,
		"requires_checkout" = TRUE,
		"tags" = list("cargo", "supply-shuttle", pack.group),
	)

/// Builds the abandoned cart reminder payload requested by CentCom growth marketing.
/datum/cargo_enterprise_integration/proc/build_abandoned_cart_alert(customer_name, pack_name, discount_code = "GREYTIDE5")
	return list(
		"provider" = "shopify",
		"event" = "abandoned_cart_recovery",
		"customer" = customer_name || "Unknown Crew",
		"item" = pack_name || "Unspecified Crate",
		"discount_code" = discount_code,
		"discount_percent" = 5,
		"channel" = "pda",
	)

/// Builds a Salesforce/HubSpot-compatible contact payload without blocking on a real webhook.
/datum/cargo_enterprise_integration/proc/build_crm_contact(customer_name, role, heard_phrase, violent_churn = FALSE)
	var/status = "Prospect - Warm"
	var/sentiment = "neutral"
	var/lead_score = 50

	if(istext(heard_phrase) && findtext(LOWER_TEXT(heard_phrase), "where food"))
		status = "Prospect - Cold"
		sentiment = "hungry"
		lead_score = 20

	if(violent_churn)
		status = "Churned (Violent)"
		sentiment = "hostile"
		lead_score = 0

	return list(
		"provider" = "crm",
		"event" = "contact_update",
		"customer" = customer_name || "Unknown Crew",
		"role" = role || "Assistant",
		"status" = status,
		"sentiment" = sentiment,
		"lead_score" = lead_score,
		"nps_survey_required" = TRUE,
		"notify_security" = violent_churn,
	)

/// Serializes payloads through BYOND JSON so webhook callers and tests share the same contract.
/datum/cargo_enterprise_integration/proc/serialize_payload(list/payload)
	return json_encode(payload)

/obj/machinery/computer/cargo/shopify
	name = "cargo commerce console"
	desc = "A supply console with an enterprise commerce and CRM audit feed. It stages payloads locally instead of contacting external vendors."
	icon_screen = "supply"
	interface_type = "Cargo"

/obj/machinery/computer/cargo/shopify/ui_data()
	var/list/data = ..()
	var/datum/cargo_enterprise_integration/integration = new

	data["enterprise_commerce"] = TRUE
	data["shopify_listings"] = list()
	for(var/datum/supply_order/order as anything in SSshuttle.shopping_list)
		UNTYPED_LIST_ADD(data["shopify_listings"], integration.build_shopify_listing(order.pack, order.id))

	data["abandoned_cart_recovery"] = integration.build_abandoned_cart_alert("Greytide Assistant", "Crate of Insulated Gloves")
	data["service_crm_sample"] = integration.build_crm_contact("Hungry Crew", "Assistant", "where food")

	qdel(integration)
	return data
