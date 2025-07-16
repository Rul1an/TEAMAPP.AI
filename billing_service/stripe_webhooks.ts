/**
 * Stripe Webhook Handler – Usage-Based Billing
 *
 * Exposes a single `handleStripeWebhook` function compatible with edge runtimes.
 * It validates the webhook signature, persists usage-records and keeps
 * subscription metadata in sync with internal accounts.
 *
 * ENV VARS (in CI / prod):
 *   STRIPE_SECRET            – Secret API key
 *   STRIPE_WEBHOOK_SECRET    – Endpoint signing secret
 */

import Stripe from 'stripe';

const STRIPE_SECRET = process.env.STRIPE_SECRET;
if (!STRIPE_SECRET) {
  throw new Error('Missing STRIPE_SECRET environment variable');
}

const stripe = new Stripe(STRIPE_SECRET, {
  apiVersion: '2023-10-16',
  typescript: true,
});

export async function handleStripeWebhook(request: Request): Promise<Response> {
  const sig = request.headers.get('stripe-signature');
  if (!sig) return new Response('Missing signature', { status: 400 });

  const payload = await request.text();
  let event: Stripe.Event;
  try {
    event = stripe.webhooks.constructEvent(payload, sig, process.env.STRIPE_WEBHOOK_SECRET ?? '');
  } catch (err) {
    console.error('Webhook signature verification failed', err);
    return new Response('Signature verification failed', { status: 400 });
  }

  switch (event.type) {
    case 'usage_record.summary.created':
      await onUsageSummary(event as Stripe.Event & { data: { object: Stripe.UsageRecordSummary } });
      break;
    case 'invoice.paid':
      await onInvoicePaid(event as Stripe.Event & { data: { object: Stripe.Invoice } });
      break;
    case 'customer.subscription.deleted':
      await onSubscriptionDeleted(event as Stripe.Event & { data: { object: Stripe.Subscription } });
      break;
    default:
      console.log(`Unhandled event type ${event.type}`);
  }

  return new Response('ok', { status: 200 });
}

export default { fetch: handleStripeWebhook };

async function onUsageSummary(evt: Stripe.Event & { data: { object: Stripe.UsageRecordSummary } }) {
  // TODO: Persist usage metrics to analytics DB for reconciliation
  console.log('Usage summary', evt.data.object.id);
}

async function onInvoicePaid(evt: Stripe.Event & { data: { object: Stripe.Invoice } }) {
  // TODO: Mark invoice as paid in internal billing DB
  console.log('Invoice paid', evt.data.object.id);
}

async function onSubscriptionDeleted(evt: Stripe.Event & { data: { object: Stripe.Subscription } }) {
  // TODO: Deactivate subscription in internal accounts DB
  console.log('Subscription deleted', evt.data.object.id);
}