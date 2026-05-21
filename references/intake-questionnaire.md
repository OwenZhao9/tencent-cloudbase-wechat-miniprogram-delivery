# Intake Questionnaire

Use this when the user has no code, an incomplete handoff, or unclear customer requirements. Ask only the minimum blocking questions first. Prefer proceeding with explicit assumptions over waiting for perfect information.

## Question Policy

- Ask at most 6 questions in the first intake.
- Group related choices into one question when possible.
- Do not ask for information that can be discovered from files, console output, or the current workspace.
- If the user says "you decide" or wants speed, choose the MVP default path and list assumptions.
- After receiving answers, summarize the implementation plan in 5-8 bullets and start work.

## First Intake for No-Code Projects

Ask these first:

1. What industry is this mini program for?
   - Examples: medicine shop, vegetable wholesale, restaurant ordering, campus canteen, housekeeping, appointment booking.
2. What is the core transaction?
   - Examples: product purchase, service booking, inquiry lead, pickup order, delivery order.
3. Which functions are required for the first deliverable?
   - Product/category management
   - Search
   - Cart/order
   - Coupons
   - Poster/share
   - Map navigation
   - Local delivery
   - Online payment
4. Do real WeChat and CloudBase resources already exist?
   - Mini Program AppID
   - CloudBase `envId`
   - CloudBase console access
   - WeChat Developer Tools login
5. Does the customer need a trial link/version or source-code delivery first?
6. Are there brand assets or data to import?
   - Logo
   - store name
   - categories
   - product list
   - images
   - phone/address

## Defaults When the User Wants Speed

Use these defaults if the user gives no answer:

- Build an MVP mall flow.
- Include admin web app, WeChat Mini Program frontend, CloudBase NoSQL collections, and optional cloud functions only when needed.
- Use product/category/order/store-config collections.
- Skip real payment until merchant payment configuration is available.
- Use real CloudBase data; do not use mock data after CloudBase is connected.
- Prepare a customer test path: admin creates product -> mini program displays product -> user submits order -> admin updates order.

## Existing Code Intake

If code exists, ask only missing items:

- Admin project path, if not obvious.
- Mini program project path containing `project.config.json`, if not obvious.
- CloudBase `envId`, if not in code/config.
- Mini Program AppID, if not in `project.config.json`.
- Customer acceptance flow, if requirements are ambiguous.
- Test account or console access, if required for deployment or verification.

## CloudBase Readiness Questions

Ask these only when the answer cannot be discovered:

- Is the AppID already associated with the CloudBase environment?
- Are database permissions supposed to allow public read, authenticated read, or admin-only write?
- Should admin write directly to CloudBase from the web SDK, through cloud functions, or through an existing backend?
- Is static hosting or HTTP access service enabled for the admin backend?
- Does the customer need China mainland domain filing/备案 for production access?

## Output After Intake

After answers, produce:

- Assumptions
- MVP scope
- Data model
- Pages/admin modules
- CloudBase resources
- Verification flow
- Delivery format

Then implement; do not stop at planning unless the user asks for planning only.
