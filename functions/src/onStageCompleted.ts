import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

const DIFFICULTY_MULTIPLIERS: Record<string, number> = {
  easy: 1.0, medium: 1.5, hard: 2.0, legendary: 3.0,
};

/**
 * Triggered when stageProgress changes on a UserQuest.
 * Awards stage XP and checks if all stages are complete.
 */
export const onStageCompleted = functions.firestore
  .document('users/{userId}/quests/{userQuestId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    if (!after.stageProgress || !before.stageProgress) return;
    if (after.status === 'completed') return;

    const newlyCompleted = (after.stageProgress as any[]).filter(
      (stage: any, i: number) =>
        stage.status === 'completed' &&
        (before.stageProgress[i]?.status !== 'completed'),
    );

    if (newlyCompleted.length === 0) return;

    const { userId } = context.params;
    const questSnap = await db.collection('quests').doc(after.questId).get();
    if (!questSnap.exists) return;
    const quest = questSnap.data()!;
    const multiplier = DIFFICULTY_MULTIPLIERS[quest.difficulty] || 1.0;

    // Award XP for each newly completed stage
    let totalXp = 0;
    for (const stage of newlyCompleted) {
      const stageXp = Math.round((stage.xp || 0) * multiplier);
      totalXp += stageXp;
    }

    if (totalXp > 0) {
      await db.collection('users').doc(userId).update({
        xp: admin.firestore.FieldValue.increment(totalXp),
      });
    }

    // Write activity for each stage
    for (const stage of newlyCompleted) {
      await db.collection('activity').add({
        userId,
        type: 'stageCompleted',
        questId: after.questId,
        metadata: { stageId: stage.stageId, xp: Math.round((stage.xp || 0) * multiplier) },
        createdAt: admin.firestore.Timestamp.now(),
      });
    }

    // Check if all stages complete
    const allComplete = (after.stageProgress as any[]).every(
      (s: any) => s.status === 'completed',
    );
    if (allComplete) {
      await change.after.ref.update({ status: 'completed' });
    }
  });
