## Example server-side JavaScript hooks file for PocketBase.
##
## PocketBase executes *.pb.js (or *.js) files from the --hooksDir directory
## at startup. Use this to define custom routes, business logic, and event hooks.
##
## Documentation: https://pocketbase.io/docs/js-overview/
##
## Example: log every new record creation
# onRecordCreate((e) => {
#   console.log("Created record:", e.record.id, "in", e.record.collection().name);
#   e.next();
# });
