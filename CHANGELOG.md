## 0.1.50

* Added `maxLength` constraints to all text input form fields via `BaseTextFormField`.
* Added centralized `HyttaHubLimits` constants class (`lib/utilities/constants.dart`) for input length limits and site caps.
* Limit users to a maximum of 20 sites; Create, Join, and Copy site options are greyed out when the limit is reached.
* Upgraded `protobuf` to `^6.0.0` and `protoc_plugin` to `^25.0.0`; regenerated all protobuf files.
* Upgraded `go_router` to `^17.1.0`.
* Added `WrappedRegExp` utility (`lib/utilities/pattern_utils.dart`) to avoid deprecated `RegExp` usage as `Pattern`.
* Fixed lint errors from latest Flutter SDK.

## 0.1.49

* Prepare package for pub.dev publication.
