const { onSchedule } = require('firebase-functions/v2/scheduler');
const { initializeApp } = require('firebase-admin/app');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');

initializeApp();

const db = getFirestore();
const ROTATION_DOC = db.collection('meta').doc('quote_rotation');

// All installs of the app subscribe to this topic on launch — see
// lib/services/notification_service.dart:dailyQuoteTopic. Keep the two in sync.
const TOPIC = 'daily_gita_quote';

// Rotates through gita_quotes in `number` order, one per day, wrapping back
// to the start once every quote has been sent. Runs at 6am Nepal time.
exports.sendDailyGitaQuote = onSchedule(
  { schedule: '0 6 * * *', timeZone: 'Asia/Kathmandu' },
  async () => {
    const quotesSnap = await db
      .collection('gita_quotes')
      .where('is_active', '==', true)
      .orderBy('number')
      .get();

    if (quotesSnap.empty) {
      console.log('No active gita_quotes to send — skipping.');
      return;
    }

    const quotes = quotesSnap.docs.map((doc) => ({ id: doc.id, ...doc.data() }));

    const rotationSnap = await ROTATION_DOC.get();
    const lastIndex = rotationSnap.exists ? (rotationSnap.data().last_index ?? -1) : -1;
    const nextIndex = (lastIndex + 1) % quotes.length;
    const quote = quotes[nextIndex];

    const body = quote.meaning_devanagari
      ? `${quote.text_devanagari}\n\nअर्थ: ${quote.meaning_devanagari}`
      : quote.text_devanagari;

    // Deliberately a data-only message (no top-level `notification` field):
    // that stops Android from auto-rendering its own flattened, single-line
    // notification and hands rendering entirely to the app, which builds it
    // with BigTextStyle so the blank line before "अर्थ:" actually survives on
    // screen — see lib/services/notification_service.dart.
    await getMessaging().send({
      topic: TOPIC,
      data: {
        title: 'आजको श्रीमद्भगवद गीता वचन',
        body,
        quote_id: quote.id,
        chapter_verse: quote.chapter_verse || '',
      },
    });

    await ROTATION_DOC.set(
      { last_index: nextIndex, last_sent_at: FieldValue.serverTimestamp() },
      { merge: true },
    );

    console.log(`Sent quote #${quote.number} (rotation index ${nextIndex} of ${quotes.length}).`);
  },
);
