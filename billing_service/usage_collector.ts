import Stripe from 'stripe';

const STRIPE_SECRET = process.env.STRIPE_SECRET;
if (!STRIPE_SECRET) {
  throw new Error('Missing STRIPE_SECRET environment variable');
}

const stripe = new Stripe(STRIPE_SECRET, {
  apiVersion: '2023-10-16',
  typescript: true,
});

/**
 * Records metered usage against a subscription item id.
 * @param subscriptionItemId Stripe subscription_item id
 * @param quantity amount of usage units (e.g. minutes, requests)
 * @param timestamp epoch seconds (defaults to now)
 */
export async function recordMeteredUsage(
  subscriptionItemId: string,
  quantity: number,
  timestamp: number = Math.floor(Date.now() / 1000),
) {
  if (!subscriptionItemId) throw new Error('Missing subscriptionItemId');
  if (quantity <= 0) throw new Error('Quantity must be > 0');
  return stripe.subscriptionItems.createUsageRecord(subscriptionItemId, {
    quantity,
    timestamp,
    action: 'increment',
  });
}

// CLI helper: ts-node billing_service/usage_collector.ts <item_id> <qty>
if (require.main === module) {
  const [itemId, qtyStr] = process.argv.slice(2);
  const qty = Number(qtyStr ?? '1');
  recordMeteredUsage(itemId, qty)
    .then((rec) => {
      console.log('Usage recorded', rec.id);
    })
    .catch((err) => {
      console.error('Error recording usage', err);
      process.exit(1);
    });
}