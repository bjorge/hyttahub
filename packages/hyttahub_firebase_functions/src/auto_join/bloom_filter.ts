import * as crypto from "crypto";

export const defaultBloomFilterSize = 240;
export const defaultBloomFilterHashCount = 7;

export class BloomFilterProcessor {
  size: number;
  hashCount: number;
  bitArray: Uint8Array;

  constructor(size: number, hashCount: number, bitArray?: Uint8Array) {
    this.size = size;
    this.hashCount = hashCount;
    this.bitArray = bitArray || new Uint8Array(Math.ceil(size / 8));
  }

  add(item: string) {
    for (let i = 0; i < this.hashCount; i++) {
      const hash = this._hash(item, i);
      const bitIndex = hash % this.size;
      this._setBit(bitIndex);
    }
  }

  addAll(items: string[]) {
    for (const item of items) {
      this.add(item);
    }
  }

  private _setBit(bitIndex: number) {
    const byteIndex = Math.floor(bitIndex / 8);
    const bitMask = 1 << (bitIndex % 8);
    this.bitArray[byteIndex] |= bitMask;
  }

  mightContain(item: string): boolean {
    for (let i = 0; i < this.hashCount; i++) {
      const hash = this._hash(item, i);
      const bitIndex = hash % this.size;
      const byteIndex = Math.floor(bitIndex / 8);
      const bitMask = 1 << (bitIndex % 8);
      if ((this.bitArray[byteIndex] & bitMask) === 0) {
        return false;
      }
    }
    return true;
  }

  private _hash(input: string, seed: number): number {
    const h = crypto.createHash("sha256");
    h.update(`${seed}:${input}`);
    const digest = h.digest();
    // Match Dart's ByteData.getUint32(0) which is Big-endian
    return digest.readUInt32BE(0);
  }
}
