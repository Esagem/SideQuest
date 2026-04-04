import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

/**
 * Runs hourly to precompute leaderboard rankings.
 */
export const computeLeaderboards = functions.pubsub
  .schedule('0 * * * *')
  .timeZone('UTC')
  .onRun(async () => {
    // Global leaderboard — top 100 by XP
    const globalSnap = await db.collection('users')
      .orderBy('xp', 'desc')
      .limit(100)
      .get();

    const globalEntries = globalSnap.docs.map((doc, i) => ({
      rank: i + 1,
      userId: doc.id,
      displayName: doc.data().displayName || '',
      username: doc.data().username || '',
      avatarUrl: doc.data().avatarUrl || null,
      tier: doc.data().tier || 'novice',
      xp: doc.data().xp || 0,
      questsCompleted: doc.data().questsCompleted || 0,
      badgeShowcase: doc.data().badgeShowcase || [],
    }));

    await db.collection('leaderboards').doc('global').set({
      entries: globalEntries,
      updatedAt: admin.firestore.Timestamp.now(),
    });

    // Weekly leaderboard — compute from activity in last 7 days
    const weekAgo = new Date();
    weekAgo.setDate(weekAgo.getDate() - 7);
    const weeklySnap = await db.collection('activity')
      .where('type', '==', 'questCompleted')
      .where('createdAt', '>=', admin.firestore.Timestamp.fromDate(weekAgo))
      .get();

    const weeklyXp: Record<string, number> = {};
    for (const doc of weeklySnap.docs) {
      const data = doc.data();
      weeklyXp[data.userId] = (weeklyXp[data.userId] || 0) + (data.metadata?.xp || 0);
    }

    const weeklyRanked = Object.entries(weeklyXp)
      .sort(([, a], [, b]) => b - a)
      .slice(0, 100);

    const weeklyEntries = await Promise.all(
      weeklyRanked.map(async ([userId, xp], i) => {
        const userSnap = await db.collection('users').doc(userId).get();
        const user = userSnap.data() || {};
        return {
          rank: i + 1, userId,
          displayName: user.displayName || '', username: user.username || '',
          avatarUrl: user.avatarUrl || null, tier: user.tier || 'novice',
          xp, questsCompleted: user.questsCompleted || 0,
          badgeShowcase: user.badgeShowcase || [],
        };
      }),
    );

    await db.collection('leaderboards').doc('weekly').set({
      entries: weeklyEntries,
      updatedAt: admin.firestore.Timestamp.now(),
    });
  });
