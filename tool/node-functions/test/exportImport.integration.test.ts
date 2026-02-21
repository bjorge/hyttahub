import * as unzipper from 'unzipper';
const archiver = require('archiver');
import { extractEventsAndPhotosFromZip } from '../src/backup_functions/backup_functions';

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

describe('export -> import round-trip', () => {
  test('round-trip preserves events.txt and photos', async () => {
    // Simulate two base64-encoded event lines (these could be actual records)
    const fakeEvent1 = Buffer.from('event1').toString('base64');
    const fakeEvent2 = Buffer.from('event2').toString('base64');
    const eventsTxt = `${fakeEvent1}\n${fakeEvent2}\n`;

    const photo1 = Buffer.from([10, 20, 30]);
    const photo2 = Buffer.from([40, 50, 60]);

    const zipBuffer = await createZip([
      { name: 'events.txt', content: eventsTxt },
      { name: 'storage/photo1.jpg', content: photo1 },
      { name: 'storage/nested/photo2.png', content: photo2 },
    ]);

    const directory = await unzipper.Open.buffer(zipBuffer as Buffer);

    const { eventsContent, photos } = await extractEventsAndPhotosFromZip(directory);

    // events should match
    expect(eventsContent).toBe(eventsTxt);

    // photos should match by relativePath and buffer
    const byPath = new Map(photos.map((p) => [p.relativePath, p.buffer] as [string, Buffer]));
    expect(byPath.get('photo1.jpg')).toEqual(photo1);
    expect(byPath.get('nested/photo2.png')).toEqual(photo2);
  });
});
