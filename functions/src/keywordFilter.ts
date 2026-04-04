import * as functions from 'firebase-functions';

const BLOCKLIST = [
  'spam', 'scam', 'illegal',
  // Add more blocked terms as needed
];

/**
 * Callable function to check text against a keyword blocklist.
 * Returns { pass: boolean, flaggedWords: string[] }
 */
export const keywordFilter = functions.https.onCall((data) => {
  const text: string = (data.text || '').toLowerCase();
  const flaggedWords = BLOCKLIST.filter((word) => text.includes(word));
  return {
    pass: flaggedWords.length === 0,
    flaggedWords,
  };
});
