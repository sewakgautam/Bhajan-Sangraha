const admin = require('firebase-admin');

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  projectId: 'bhajan-sangraha-pahadilabs',
});

const db = admin.firestore();

// Fill in the bhajans you want to attach a YouTube video to. Key is the
// bhajan number (matches `bhajan-XXX` doc ids); value is any YouTube URL
// (watch, youtu.be, or shorts — the app parses all three formats).
const youtubeUrls = {
  // 1: 'https://www.youtube.com/watch?v=XXXXXXXXXXX',
};

(async () => {
  const entries = Object.entries(youtubeUrls);
  if (entries.length === 0) {
    console.log('No entries in youtubeUrls — edit this file first.');
    return;
  }

  const batch = db.batch();
  for (const [number, url] of entries) {
    const id = `bhajan-${String(number).padStart(3, '0')}`;
    const ref = db.collection('bhajans').doc(id);
    batch.update(ref, {
      youtube_url: url,
      updated_at: admin.firestore.FieldValue.serverTimestamp(),
    });
  }
  await batch.commit();
  console.log(`Set youtube_url on ${entries.length} bhajan(s).`);
})().catch((e) => {
  console.error('UPDATE FAILED', e);
  process.exit(1);
});
