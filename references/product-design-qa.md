# Product, Design, Engineering, and QA Gates

Use these gates locally as review roles. They are checkpoints for the same agent unless the user explicitly asks for multiple subagents.

## Product Manager Gate

- Convert vague requests into testable user outcomes.
- Identify the main users: merchant/admin, mini program customer, delivery/operator, and project owner.
- Require an acceptance path for every paid feature:
  - Store decoration: merchant can change visible store content or template settings.
  - Product management: merchant can create, edit, publish, unpublish, and search products.
  - Order management: merchant can see orders, change statuses, and inspect customer/order details.
  - Online payment: payment entry exists only if real payment config is ready; otherwise state the config gap.
  - Search: mini program search returns real CloudBase data.
  - Poster/share: user can generate or invoke a shareable poster/share flow.
  - Coupons: user can receive and use coupons; merchant can verify/reconcile them.
  - Online mall: user can add products to cart and place an order.
  - Map navigation: user can see real store location and open navigation.
  - Local delivery: order flow captures delivery information and merchant can process it.
- For customer trials, prefer one concise scenario over a feature list: admin adds a product, mini program sees it, user orders it, merchant processes it.

## Designer Gate

- Apply only to new or changed UI, not purely backend fixes.
- Match the existing mini program or admin design system before inventing a new style.
- Check mobile constraints: no overlapping text, clipped labels, unbounded cards, shifting toolbars, or unreachable controls.
- Keep operational/admin screens dense and clear. Avoid marketing-style hero sections for backend dashboards.
- For mini program pages, verify tab bars, sticky action bars, and cards stay readable on narrow phones.

## Full-Stack Engineer Gate

- Trace each feature through the real code path:
  - UI event handler
  - service/API wrapper
  - CloudBase collection or cloud function
  - permission rule
  - data returned to the mini program
- Prefer existing service modules and schema helpers.
- Do not hide CloudBase failures behind fallback data. Fix missing collections, permissions, AppID association, environment IDs, and field mismatches.
- For admin-to-mini-program sync, prove one mutation: create/edit/unpublish in admin, then refresh mini program and verify the changed state.
- For deployment, record the exact public admin URL, CloudBase environment, and any domain/CORS/auth constraints.

## QA Engineer Gate

- Test the highest-risk path first: fresh launch, fetch categories, fetch recommendations/products, search, detail, cart/order, admin mutation, mini program refresh.
- Capture the exact error text and stack source. A stack in project files is higher priority than a stack only in WeChat internal runtime files.
- Separate blockers from warnings:
  - Blocker: collection missing, permission denied, app not associated, cloud function missing, write/read failure.
  - Warning: deprecated API notice, DevTools font cache miss, unsupported realtime action warning.
- Re-run after cache-clearing or DevTools restart when errors are WeChat internal `timeout` or stale page stack issues.
- End with evidence: commands run, screens exercised, data record used, and what remains unverified.
