import { NativeModules, NativeEventEmitter } from 'react-native';

import { createErrorFromErrorData } from './utils';

const RNAdManager = NativeModules.RNAdManager;

const eventEmitter = new NativeEventEmitter(RNAdManager);

const eventMap = {
  adLoaded: 'nativeAdLoaded',
  adFailedToLoad: 'nativeAdFailedToLoad'
};

class AdManager {
  constructor(adUnit, adsToRequest = 1) {
    console.log('AdManager.constructor');
    this._subscriptions = new Map();
    this.hasAds = false;
    this.numAds = 0;

    this.adUnit = adUnit;
    this.adsToRequest = adsToRequest;

    RNAdManager.setAdUnitID(adUnit);
  }

  requestAd() {
    console.log('AdManager.requestAds');
    RNAdManager.requestAd();
  }
  getHasAds() {
    console.log('AdManager.getHasAds');
    return this.hasAds;
  }

  getNumAds() {
    console.log('AdManager.getNumAds');
    return this.numAds;
  }

  addEventListener(event, handler) {
    console.log('AdManager.addEventListener');
    const mappedEvent = eventMap[event];
    if (mappedEvent) {
      let listener;
      if (event === 'adFailedToLoad') {
        listener = eventEmitter.addListener(mappedEvent, error => {
          console.log('AdManager.adFailedToLoad');
          handler(createErrorFromErrorData(error));
        });
      } else if (event === 'adLoaded') {
        listener = eventEmitter.addListener(mappedEvent, () => {
          console.log('AdManager.adLoaded');
          this.hasAds = true;
          this.numAds++;

          handler();
        });
      } else {
        listener = eventEmitter.addListener(mappedEvent, handler);
      }
      this._subscriptions.set(handler, listener);
      return {
        remove: () => removeEventListener(event, handler)
      };
    } else {
      // eslint-disable-next-line no-console
      console.warn(`Trying to subscribe to unknown event: "${event}"`);
      return {
        remove: () => {}
      };
    }
  }

  removeEventListener(type, handler) {
    console.log('AdManager.removeEventListener');
    const listener = this._subscriptions.get(handler);
    if (!listener) {
      return;
    }
    listener.remove();
    this._subscriptions.delete(handler);
  }

  removeAllListeners() {
    console.log('AdManager.removeAllListeners');
    this._subscriptions.forEach((listener, key, map) => {
      listener.remove();
      map.delete(key);
    });
  }
}

export default AdManager;
