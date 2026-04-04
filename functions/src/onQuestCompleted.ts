import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

const BASE_XP = 100;
const DIFFICULTY_MULTIPLIERS: Record<string, number> = {
  easy: 1.0,
  medium: 1.5,
  hard: 2.0,
  legendary: 3.0,
};
const FIRST_COMPLETION_BONUS = 50;
const CHALLENGE_BONUS = 25;
const PEOPLE_BONUS = 10;

/**
 * Triggered when a UserQuest status changes to "completed".
 * Calculates XP, updates user stats, checks badges/streak, writes activity.
 */
export const onQuestCompleted = functions.firestore
  .document('users/{userId}/quests/{userQuestId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    if (before.status === 'completed' || after.status !== 'completed') return;

    const { userId } = context.params;
    const questId = after.questId;

    // Fetch quest data
    const questSnap = await db.collection('quests').doc(questId).get();
    if (!questSnap.exists) return;
    const quest = questSnap.data()!;

    // Calculate XP
    const multiplier = DIFFICULTY_MULTIPLIERS[quest.difficulty] || 1.0;
    let xp = Math.round(BASE_XP * multiplier);

    // First completion bonus
    if (quest.completedCount === 0) xp += FIRST_COMPLETION_BONUS;

    // Bonus block
    if (quest.blocks?.bonus?.xpBonus) {
      xp += quest.blocks.bonus.xpBonus;
    }

    // Update user stats
    const userRef = db.collection('users').doc(userId);
    await userRef.update({
      xp: admin.firestore.FieldValue.increment(xp),
      questsCompleted: admin.firestore.FieldValue.increment(1),
      lastCompletionDate: admin.firestore.Timestamp.now(),
      currentStreak: admin.firestore.FieldValue.increment(1),
      updatedAt: admin.firestore.Timestamp.now(),
    });

    // Update quest completedCount
    await db.collection('quests').doc(questId).update({
      completedCount: admin.firestore.FieldValue.increment(1),
    });

    // Update tier
    const userSnap = await userRef.get();
    const userData = userSnap.data();
    if (userData) {
      const totalXp = userData.xp || 0;
      let tier = 'novice';
      if (totalXp >= 15000) tier = 'legend';
      else if (totalXp >= 5000) tier = 'trailblazer';
      else if (totalXp >= 2000) tier = 'adventurer';
      else if (totalXp >= 500) tier = 'explorer';
      await userRef.update({ tier });

      // Update longest streak
      if ((userData.currentStreak || 0) > (userData.longestStreak || 0)) {
        await userRef.update({ longestStreak: userData.currentStreak });
      }
    }

    // Update XP on user quest
    await change.after.ref.update({ xpEarned: xp });

    // Write activity
    await db.collection('activity').add({
      userId,
      type: 'questCompleted',
      questId,
      proofUrl: after.proofUrl || null,
      metadata: { xp, difficulty: quest.difficulty },
      createdAt: admin.firestore.Timestamp.now(),
    });

    // Handle challenge completion
    const challengeSnap = await db.collection('challenges')
      .where('receiverId', '==', userId)
      .where('questId', '==', questId)
      .where('status', '==', 'accepted')
      .limit(1)
      .get();

    if (!challengeSnap.empty) {
      const challenge = challengeSnap.docs[0];
      await challenge.ref.update({ status: 'completed' });
      // Award challenger bonus XP
      await db.collection('users').doc(challenge.data().senderId).update({
        xp: admin.firestore.FieldValue.increment(CHALLENGE_BONUS),
      });
      await db.collection('activity').add({
        userId: challenge.data().senderId,
        type: 'challengeCompleted',
        questId,
        metadata: { xp: CHALLENGE_BONUS, challengedUser: userId },
        createdAt: admin.firestore.Timestamp.now(),
      });
    }
  });
