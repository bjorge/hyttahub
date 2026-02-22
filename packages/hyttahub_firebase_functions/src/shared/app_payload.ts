import { AppEventWrapper } from "../ts/app_wrapper";
import { SiteEvent } from "../ts/site_events";

/**
 * Creates a SiteEvent, encodes it, and returns it as a base64 string.
 * @param {Uint8Array} encodedAppEvent The encoded AppEvent payload.
 * @param {number} author The author of the event.
 * @param {number} version The version of the event.
 * @return {string} The base64 encoded SiteEvent payload.
 */
export function createSiteEventPayload(encodedAppEvent: Uint8Array, author: number, version: number): string {
  const siteEvent = SiteEvent.create({
    appEvent: AppEventWrapper.create({
      payload: encodedAppEvent,
    }),
    version: version,
    author: author,
  });
  return Buffer.from(SiteEvent.encode(siteEvent).finish()).toString("base64");
}