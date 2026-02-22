import { BloomFilterProcessor, defaultBloomFilterSize, defaultBloomFilterHashCount } from '../src/auto_join/bloom_filter';

describe('BloomFilterProcessor', () => {
  test('initializes with correct size and hash count', () => {
    const filter = new BloomFilterProcessor(100, 3);
    expect(filter.size).toBe(100);
    expect(filter.hashCount).toBe(3);
    // Bit array should be initialized to zeros
    expect(filter.bitArray.every(b => b === 0)).toBe(true);
  });

  test('can add and check items', () => {
    const filter = new BloomFilterProcessor(defaultBloomFilterSize, defaultBloomFilterHashCount);
    
    expect(filter.mightContain('test@example.com')).toBe(false);
    expect(filter.mightContain('user@domain.com')).toBe(false);

    filter.add('test@example.com');

    expect(filter.mightContain('test@example.com')).toBe(true);
    expect(filter.mightContain('user@domain.com')).toBe(false); // Possible false positive, but highly unlikely with defaults
  });

  test('can add multiple items', () => {
    const filter = new BloomFilterProcessor(1000, 5);
    const emails = ['a@a.com', 'b@b.com', 'c@c.com'];
    
    filter.addAll(emails);

    for (const email of emails) {
      expect(filter.mightContain(email)).toBe(true);
    }
    expect(filter.mightContain('d@d.com')).toBe(false);
  });
});
