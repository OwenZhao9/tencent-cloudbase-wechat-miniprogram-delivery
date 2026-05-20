# Delivery and Customer Trial Checklist

Use this before creating customer instructions, package ZIPs, or sending files through WeChat.

## Customer Trial Flow

Give the customer one clean path:

1. Open the admin backend URL.
2. Log in with the provided test account, if login is enabled.
3. Create or edit one product:
   - product name
   - category
   - price
   - stock
   - image
   - published/on-shelf status
4. Open the mini program preview or experience version.
5. Refresh the home/category page.
6. Search the exact product name.
7. Open product detail and verify image, price, and stock.
8. Add to cart and submit a test order.
9. Return to admin backend.
10. Find the order and change its status.
11. Refresh the mini program order page and verify the status changed.

If payment is not configured, explicitly mark payment as configuration-pending and test order submission without real payment.

## Before Packaging

- Run available checks: install/build/lint/tests where present.
- Recompile the mini program in WeChat Developer Tools.
- Verify CloudBase environment ID and AppID are not placeholder values.
- Verify no activation locks, hidden blockers, or intentional disablement remain unless the user explicitly requests them.
- Verify documentation does not mention internal payment/activation strategy unless the user asked for it.
- Check for secrets:
  - `.env`
  - `.env.local`
  - private keys
  - CloudBase secret keys
  - `project.private.config.json`
  - tokens inside docs or screenshots

## ZIP Contents

Include:

- admin source code
- mini program source code
- cloud functions
- lockfiles
- README or usage docs requested by the user
- sanitized `.env.example`
- deployment notes when useful

Exclude:

- `node_modules`
- `.git`
- local logs and caches
- `.DS_Store`
- private env files
- IDE state
- AI working folders such as `.codex`, `.agents`, `.codebuddy` unless the user asks to include them
- temporary archives from previous deliveries

## WeChat Send Flow

1. Confirm target chat name exactly. If multiple contacts/groups match, ask the user to disambiguate.
2. Generate or locate the final ZIP.
3. Use desktop automation/Finder only when needed to attach the file.
4. If macOS asks for Automation or accessibility permission, explain it is needed for selecting or sending the file.
5. Verify the file card appears in the intended chat.
6. Send only after the recipient and file are both visible.
7. Report the ZIP path, file size, and recipient.

## Final Handoff Summary

Keep the final message concise:

- What was packaged or deployed.
- Where the ZIP is.
- What was verified.
- Any remaining external setup, such as CloudBase permissions, payment merchant config, domain filing, or customer test account.
