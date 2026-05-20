---
name: tencent-cloudbase-wechat-miniprogram-delivery
description: Build, debug, test, package, and hand off WeChat Mini Program projects that use Tencent CloudBase, including mini program frontends, admin backends, CloudBase NoSQL/cloud functions/storage/static hosting, WeChat Developer Tools debugging, full admin-to-mini-program integration testing, customer trial preparation, delivery ZIP creation, and sending packages to a specified WeChat contact or group.
---

# Tencent CloudBase WeChat Mini Program Delivery

Use this skill for end-to-end WeChat Mini Program + Tencent CloudBase delivery work: implementation, CloudBase setup checks, front/back integration, customer testing, packaging, and WeChat handoff.

## Operating Rules

- Inspect the existing implementation before adding new structure. Patch active pages, services, route guards, cloud functions, and submit handlers; avoid detached demo pages.
- Treat CloudBase errors as root-cause issues. Do not add mock data, fallback lists, or silent catch blocks unless the user explicitly asks for a fallback.
- Keep environment identity explicit: verify `envId`, AppID, `project.config.json`, `wx.cloud.init`, and CloudBase app association before debugging data code.
- Separate product acceptance from implementation. Use local role gates from `references/product-design-qa.md`; do not spawn subagents unless the user explicitly asks for parallel agents.
- Verify both static and runtime layers before saying done: build/lint where available, then exercise the visible admin-to-mini-program flow.
- Before packaging or sending, read `references/delivery-checklist.md` and use `scripts/package_delivery.sh` unless the project requires a custom package layout.

## Workflow

1. **Orient**
   - Identify project roots: admin web app, mini program root containing `project.config.json`, cloud functions, and docs.
   - Read the closest `AGENTS.md`, `README.md`, `package.json`, `app.json`, `project.config.json`, and active data services.
   - Confirm current goal: implement missing requirements, debug live data, prepare customer trial, package delivery, or send files.

2. **Check CloudBase readiness**
   - Confirm `envId`, AppID, cloud development status, AppID-to-environment association, collection existence, collection permissions, and required cloud functions.
   - Prefer official CloudBase tools when available. If not, use the console/CLI/browser only for the minimum required operation.
   - For mini programs, confirm the code uses `wx.cloud` and the app-side CloudBase environment, not only admin-side credentials.

3. **Implement**
   - Patch the real data flow: admin form -> CloudBase collection/function -> mini program list/search/detail/cart/order.
   - Keep data schemas aligned. Normalize only at clear boundaries; do not duplicate incompatible field names across admin and mini program.
   - For new visual UI work, follow the repository's UI rules and existing design system first.

4. **Debug integration**
   - Use `references/cloudbase-miniprogram-debugging.md` when WeChat Developer Tools or CloudBase reports errors.
   - Distinguish app errors from DevTools/system warnings. App file stacks, collection errors, and permission errors are actionable; renderer font/cache warnings may be environmental.
   - Reproduce after each fix with Cmd+R/recompile, fresh page navigation, and at least one real data mutation from the admin side.

5. **Run acceptance gates**
   - Product manager gate: every requested capability has a customer-visible acceptance path.
   - Designer gate: new or changed screens are coherent on mobile and do not overlap or clip.
   - Full-stack gate: data writes, reads, permissions, deployment config, and environment IDs are correct.
   - QA gate: document exact test evidence, unresolved warnings, and any risk the user must know.

6. **Package and hand off**
   - Generate a clean ZIP with `scripts/package_delivery.sh`.
   - Exclude dependencies, `.git`, private env files, local IDE state, logs, caches, and AI working folders.
   - Include source code, cloud functions, useful docs, lockfiles, and sanitized `.env.example` files.
   - When asked to send through WeChat, use desktop automation only after the recipient or group is unambiguous. Confirm the file card is attached to the correct chat before sending.

## Reference Selection

- Read `references/product-design-qa.md` when planning requirements coverage, design review, or QA gates.
- Read `references/cloudbase-miniprogram-debugging.md` when debugging CloudBase, WeChat Developer Tools, database collections, permissions, AppID association, font/cache warnings, or `timeout` errors.
- Read `references/delivery-checklist.md` before customer testing, package creation, Word/TXT handoff docs, or WeChat delivery.

## Packaging Script

Run the skill-local script from any project directory:

```bash
${CODEX_HOME:-$HOME/.codex}/skills/tencent-cloudbase-wechat-miniprogram-delivery/scripts/package_delivery.sh \
  --admin /path/to/admin \
  --miniprogram /path/to/miniprogram \
  --out /path/to/output \
  --name customer-project
```

Use `--include-build` only when the user wants built artifacts such as `dist/` or `build/` inside the ZIP.
