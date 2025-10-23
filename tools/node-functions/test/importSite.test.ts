import * as unzipper from 'unzipper';
const archiver = require('archiver');
import { extractEventsAndPhotosFromZip } from '../src/backup_functions/backup_functions';
import { HttpsError } from 'firebase-functions/v2/https';

// Helper to create an in-memory zip buffer with given entries
async function createZip(entries: { name: string; content: Buffer | string }[]) {
  const archive = archiver('zip', { zlib: { level: 9 } });
  const bufs: Buffer[] = [];

  archive.on('data', (chunk: Buffer) => bufs.push(Buffer.from(chunk)));

  for (const entry of entries) {
    archive.append(entry.content, { name: entry.name });
  }

  archive.finalize();

  return new Promise<Buffer>((resolve, reject) => {
    archive.on('end', () => resolve(Buffer.concat(bufs)));
    archive.on('error', reject);
  });
}

describe('extractEventsAndPhotosFromZip', () => {
  test('throws on unexpected root-level file', async () => {
    const zipBuffer = await createZip([
      { name: 'events.txt', content: 'dummy' },
      { name: 'unexpected.txt', content: 'oops' },
    ]);

    const directory = await unzipper.Open.buffer(zipBuffer as Buffer);

    await expect(extractEventsAndPhotosFromZip(directory)).rejects.toMatchObject({
      code: 'invalid-argument',
    } as Partial<HttpsError>);
  });

  test('accepts storage/ files and returns events and photos', async () => {
    const zipBuffer = await createZip([
      { name: 'events.txt', content: 'line1\n' },
      { name: 'storage/photo1.jpg', content: Buffer.from([1, 2, 3]) },
      { name: 'storage/nested/photo2.png', content: Buffer.from([4, 5, 6]) },
    ]);

    const directory = await unzipper.Open.buffer(zipBuffer as Buffer);

    const result = await extractEventsAndPhotosFromZip(directory);

    expect(result.eventsContent).toContain('line1');
    expect(result.photos).toHaveLength(2);
    expect(result.photos[0].relativePath).toBe('photo1.jpg');
    expect(result.photos[1].relativePath).toBe('nested/photo2.png');
  });

  test('rejects archive missing events.txt', async () => {
    const zipBuffer = await createZip([
      { name: 'storage/photo1.jpg', content: Buffer.from([1, 2, 3]) },
    ]);

    const directory = await unzipper.Open.buffer(zipBuffer as Buffer);

    await expect(extractEventsAndPhotosFromZip(directory)).rejects.toMatchObject({
      code: 'invalid-argument',
    } as Partial<HttpsError>);
  });
});
