import Stripe from 'stripe';
import { collectDefaultMetrics, Gauge, Registry } from 'prom-client';
import http from 'http';

const STRIPE_SECRET = process.env.STRIPE_SECRET;
if (!STRIPE_SECRET) {
  throw new Error('Missing STRIPE_SECRET environment variable');
}

const stripe = new Stripe(STRIPE_SECRET, {
  apiVersion: '2023-10-16',
  typescript: true,
});

const register = new Registry();
collectDefaultMetrics({ register });

const gaugeMrr = new Gauge({
  name: 'stripe_estimated_mrr_usd',
  help: 'Estimated monthly recurring revenue in USD',
  registers: [register],
});

const gaugeActiveSubs = new Gauge({
  name: 'stripe_active_subscriptions_total',
  help: 'Number of active subscriptions',
  registers: [register],
});

async function updateMetrics() {
  const subs = await stripe.subscriptions.list({ status: 'active', limit: 100 });
  let mrrCents = 0;
  let count = 0;
  for (const sub of subs.data) {
    const plan = sub.items.data[0].plan;
    if (plan && plan.amount && plan.interval === 'month') {
      mrrCents += plan.amount;
    }
    count += 1;
  }
  gaugeMrr.set(mrrCents / 100);
  gaugeActiveSubs.set(count);
}

// Update immediately and then every 5 minutes
updateMetrics().catch(console.error);
setInterval(updateMetrics, 5 * 60 * 1000);

// Expose /metrics
const port = process.env.PORT ?? 9400;
http.createServer(async (req, res) => {
  if (req.url === '/metrics') {
    res.setHeader('Content-Type', register.contentType);
    res.end(await register.metrics());
  } else {
    res.writeHead(404);
    res.end();
  }
}).listen(port, () => {
  console.log(`Prometheus exporter listening on :${port}/metrics`);
});