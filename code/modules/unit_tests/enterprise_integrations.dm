/datum/unit_test/cargo_enterprise_payloads/Run()
	var/datum/cargo_enterprise_integration/integration = new
	var/datum/supply_pack/pack = new
	pack.name = "Crate of Insulated Gloves"
	pack.desc = "Protective gloves for high-value recurring engineering clients."
	pack.group = "Engineering"
	pack.cost = 1200

	var/list/listing = integration.build_shopify_listing(pack, /datum/supply_pack, 2)
	var/list/decoded_listing = safe_json_decode(integration.serialize_payload(listing))
	TEST_ASSERT(islist(decoded_listing), "Shopify listing payload did not serialize as valid JSON.")
	TEST_ASSERT_EQUAL(decoded_listing["provider"], "shopify", "Shopify listing provider was incorrect.")
	TEST_ASSERT_EQUAL(decoded_listing["event"], "draft_listing", "Shopify listing event was incorrect.")
	TEST_ASSERT_EQUAL(decoded_listing["title"], "Crate of Insulated Gloves", "Shopify listing title was incorrect.")
	TEST_ASSERT_EQUAL(decoded_listing["quantity"], 2, "Shopify listing quantity was incorrect.")
	TEST_ASSERT_EQUAL(decoded_listing["requires_checkout"], TRUE, "Shopify listing did not require checkout.")

	var/list/cart_alert = safe_json_decode(integration.serialize_payload(integration.build_abandoned_cart_alert("A. Assistant", "Tactical Shotgun Crate")))
	TEST_ASSERT_EQUAL(cart_alert["discount_code"], "GREYTIDE5", "Abandoned cart alert used the wrong discount code.")
	TEST_ASSERT_EQUAL(cart_alert["discount_percent"], 5, "Abandoned cart alert used the wrong discount percent.")
	TEST_ASSERT_EQUAL(cart_alert["channel"], "pda", "Abandoned cart alert used the wrong notification channel.")

	var/list/cold_contact = safe_json_decode(integration.serialize_payload(integration.build_crm_contact("Hungry Crew", "Chef", "where food")))
	TEST_ASSERT_EQUAL(cold_contact["status"], "Prospect - Cold", "Hungry crew contact did not receive the cold prospect status.")
	TEST_ASSERT_EQUAL(cold_contact["sentiment"], "hungry", "Hungry crew contact did not receive the hungry sentiment.")
	TEST_ASSERT_EQUAL(cold_contact["nps_survey_required"], TRUE, "CRM contact did not require an NPS survey.")

	var/list/churned_contact = safe_json_decode(integration.serialize_payload(integration.build_crm_contact("Beanbag Victim", "Bartender", "", TRUE)))
	TEST_ASSERT_EQUAL(churned_contact["status"], "Churned (Violent)", "Beanbag victim did not receive violent churn status.")
	TEST_ASSERT_EQUAL(churned_contact["notify_security"], TRUE, "Violent churn contact did not notify Security.")

	qdel(integration)
	qdel(pack)
