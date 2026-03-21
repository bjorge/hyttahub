package main

// Collection prefixes and suffixes mapped to PocketBase notation
const (
	PrefixHyttaHub = "hyttahub__"

	SuffixSiteUsers  = "__site_users"
	SuffixSiteEvents = "__site_events"
	SuffixSiteFiles  = "__site_files"

	SuffixServiceUsers  = "__service_users"
	SuffixServiceEvents = "__service_events"

	SegmentAccounts     = "__accounts__"
	SuffixAccountEvents = "__account_events"
)

// Document Document Fields matching the Dart collection_paths.dart configuration
const (
	FieldDocId      = "doc_id"
	FieldUserId     = "u"
	FieldTimeStamp  = "t"
	FieldVersion    = "v"
	FieldPayload    = "p"
	FieldMarkDelete = "m"
	FieldMarkCopy   = "c"
	FieldFile       = "file"
)
