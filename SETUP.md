# Stanley Cup Pool — Setup Guide

## Step 1: Supabase database setup
1. Go to supabase.com → your project → **SQL Editor**
2. Paste the entire contents of `schema.sql` and hit **Run**
3. You should see all tables created with no errors

## Step 2: Make yourself admin
In the SQL Editor, run:
```sql
update profiles set is_admin = true where username = 'YOUR_USERNAME';
```
(Do this after you create your account in the app for the first time)

## Step 3: Deploy to Vercel (free, 2 minutes)
1. Go to vercel.com → sign up free with GitHub
2. Click **Add New → Project**
3. Choose **"Deploy from a folder"** or drag and drop the `playoff-pool` folder
   - Or: push the folder to a GitHub repo and connect that
4. Hit Deploy — Vercel gives you a URL like `stanley-pool-abc123.vercel.app`
5. Share that URL with everyone in the pool

## Step 4: Invite players
Just send the URL. They create their own account and set their full bracket.

## Step 5: Lock Round 1 before play starts
Log in as admin → Admin tab → Lock Round 1. No more picks after that.

## Updating teams / matchups
The Round 1 matchups are hardcoded in `index.html` around line 30 in the `R1_MATCHUPS` array.
Edit team names there if needed before deploying.

---
That's it. No backend to manage, no monthly bill.
