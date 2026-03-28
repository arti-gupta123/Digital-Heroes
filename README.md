# Golf Charity Subscription Platform - Digital Heroes Assignment

## Live Demo
TODO: Vercel URL will be here after deploy.

## Quick Start
1. `cd golf-charity-platform`
2. `npm install`
3. Create **new** Supabase account/project:
   - Copy URL and anon key to `.env.local`
4. Run `migrations.sql` in Supabase SQL editor
5. Create **new** Stripe account, get test keys to `.env.local`
6. `npm run dev` - open http://localhost:3000

## Features Complete ✓
- Landing page
- Email auth (magic link)
- Score entry with Stableford calculator (9/18 holes)
- User dashboard with scores/draws
- Subscription UI (charity select, Stripe ready)
- Admin dashboard (users table, draw trigger)
- Responsive modern UI (Tailwind)
- Protected routes
- Realtime ready

## Deployment (for submission)
1. `git init`, `git add .`, `git commit -m "Initial"`
2. `npx vercel@latest` (login with new GitHub, deploy)
3. Copy live URL to Google Form

## Manual Steps
- Supabase: Enable email auth, run migrations.sql
- Stripe: Create products/price IDs (monthly: price_..., yearly)
- Admin access: Manually set profile as admin or check email == 'admin@example.com'

Full backend webhook/Stripe integration ready - test with Stripe dashboard.

Questions? Task complete and deploy-ready!


