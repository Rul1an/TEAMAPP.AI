/**
 * Stripe subscription-sync worker
 * Reconciles subscription status with internal DB (placeholder).
 * To be run via cron or GitHub Actions.
 */
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET ?? '', {
  apiVersion: '2023-10-16',
  typescript: true,
});

export async function runSync(): Promise<void> {
  const subIter = stripe.subscriptions.list({ limit: 100 });
  for await (const subscription of subIter.autoPagingEach()) {
    // TODO: upsert subscription in internal DB
    console.log(`[sync] ${subscription.id}: ${subscription.status}`);
  }
}

if (require.main === module) {
  runSync()
    .then(() => console.log('✅ Subscription sync complete'))
    .catch((err) => {
      console.error('❌ Sync error', err);
      process.exit(1);
    });
}