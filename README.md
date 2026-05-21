# Tencent CloudBase WeChat Mini Program Delivery Skill

An OpenAI Codex skill for shipping WeChat Mini Program projects that use Tencent CloudBase. It captures a practical workflow for implementation, CloudBase debugging, admin-to-mini-program integration testing, customer trial handoff, clean ZIP packaging, and optional WeChat file delivery.

## What This Skill Helps With

- WeChat Mini Program frontend implementation and debugging
- Tencent CloudBase setup checks, including `envId`, AppID association, NoSQL collections, permissions, cloud functions, storage, and static hosting
- Admin backend to mini program data synchronization
- Guided intake for no-code or incomplete projects
- WeChat Developer Tools error triage
- Full customer trial flow from backend product upload to mini program display/order testing
- Clean source-code packaging for delivery
- File handoff preparation for sending a ZIP to a WeChat contact or group

## Install

Clone this repository into your Codex skills directory:

```bash
mkdir -p ~/.codex/skills
git clone https://github.com/OwenZhao9/tencent-cloudbase-wechat-miniprogram-delivery.git \
  ~/.codex/skills/tencent-cloudbase-wechat-miniprogram-delivery
```

Restart Codex or start a new session so the skill metadata is discovered.

## Trigger Examples

Use prompts like:

```text
Use Tencent CloudBase WeChat Mini Program Delivery. I have no code yet. Ask me the required setup questions first, then build the MVP.
```

```text
Use Tencent CloudBase WeChat Mini Program Delivery to debug this mini program and admin backend.
```

```text
Use this skill to test the full flow: admin creates a product, mini program shows it, user places an order, admin processes it.
```

```text
Use this skill to package the current WeChat Mini Program and CloudBase admin project for customer delivery.
```

## Included Files

```text
SKILL.md
agents/openai.yaml
references/
  cloudbase-miniprogram-debugging.md
  delivery-checklist.md
  intake-questionnaire.md
  product-design-qa.md
scripts/
  package_delivery.sh
```

## Guided Intake Mode

For projects with no code or incomplete requirements, the skill asks only the blocking questions first:

- industry and transaction type
- required MVP features
- Mini Program AppID and CloudBase `envId` availability
- customer trial vs source-code delivery
- brand assets and initial product data

If you want speed, tell Codex to choose defaults. The skill will proceed with an MVP mall flow and list assumptions before implementation.

## Packaging Script

The packaging script creates a clean ZIP that excludes dependencies, Git metadata, local IDE state, AI working folders, private environment files, and WeChat private project config.

```bash
./scripts/package_delivery.sh \
  --admin /path/to/admin-project \
  --miniprogram /path/to/miniprogram-root \
  --out /path/to/output \
  --name customer-project
```

Use `--include-build` only when you intentionally want `dist/` or `build/` artifacts included.

## Debugging Principles

The skill intentionally prioritizes root-cause fixes over fake fallback data:

- Do not mask CloudBase permission or collection errors with mock data unless explicitly requested.
- Verify AppID, `envId`, `wx.cloud.init`, collection names, permissions, and cloud functions first.
- Treat WeChat Developer Tools internal warnings differently from real application errors.
- Prove admin-to-mini-program sync with a real mutation before handoff.

## License

MIT
