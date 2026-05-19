package main

// Fixed collection names — 7 flat collections, no dynamic creation.
const (
	ColSiteEvents    = "hyttahub_site_events"
	ColSiteUsers     = "hyttahub_site_users"
	ColSiteFiles     = "hyttahub_site_files"
	ColAccountEvents = "hyttahub_account_events"
	ColServiceEvents = "hyttahub_service_events"
	ColServiceUsers  = "hyttahub_service_users"
	ColBetaUsers     = "hyttahub_beta_users"
)

// Document field names matching the Dart collection_paths.dart configuration.
const (
	FieldDocId      = "doc_id"
	FieldUserId     = "u"
	FieldTimeStamp  = "t"
	FieldVersion    = "v"
	FieldPayload    = "p"
	FieldMarkDelete = "m"
	FieldMarkCopy   = "c"
	FieldFile       = "file"

	// Flat schema fields
	FieldApp       = "app"
	FieldSiteId    = "siteId"
	FieldAccountId = "accountId"
	FieldServiceId = "serviceId"
)
