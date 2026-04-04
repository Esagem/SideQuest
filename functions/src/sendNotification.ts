import * as admin from 'firebase-admin';

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

interface NotificationPayload {
  userId: string;
  title: string;
  body: string;
  type: string;
  targetId?: string;
}

/**
 * Sends a push notification to a user via FCM.
 * Checks user notification preferences before sending.
 */
export async function sendNotification(payload: NotificationPayload): Promise<void> {
  const userSnap = await db.collection('users').doc(payload.userId).get();
  if (!userSnap.exists) return;

  const userData = userSnap.data()!;
  const fcmToken = userData.fcmToken as string | undefined;
  if (!fcmToken) return;

  // Check notification preferences
  const prefs = userData.notificationPreferences || {};
  const typeKey = payload.type.replace(/_([a-z])/g, (_, c: string) => c.toUpperCase());
  if (prefs[typeKey] === false) return;

  await admin.messaging().send({
    token: fcmToken,
    notification: {
      title: payload.title,
      body: payload.body,
    },
    data: {
      type: payload.type,
      targetId: payload.targetId || '',
    },
    android: { priority: 'high' },
    apns: { payload: { aps: { sound: 'default' } } },
  });
}
