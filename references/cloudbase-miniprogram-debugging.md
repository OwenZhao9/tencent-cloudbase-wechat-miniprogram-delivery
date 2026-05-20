# CloudBase Mini Program Debugging

Use this reference when the mini program, admin backend, or WeChat Developer Tools reports CloudBase/data errors. Solve the real failing dependency; do not add mock/fallback behavior unless the user requests it.

## First Checks

1. Confirm the mini program root has `project.config.json` and the expected `appid`.
2. Confirm `app.js` or startup code calls `wx.cloud.init({ env: "<envId>" })` with the real CloudBase environment ID.
3. Confirm the CloudBase console has associated the mini program AppID with the environment.
4. Confirm collections referenced by code exist and contain the expected documents.
5. Confirm database permissions allow the mini program to read the required collections and the admin/backend to write them.
6. Confirm any cloud functions used by the mini program are deployed in the same environment.

## Common Errors

### `errCode: -601034` / `没有权限，请先开通云开发或者云托管`

Likely causes:

- The AppID is not associated with the CloudBase environment.
- The mini program is using the wrong environment ID.
- Cloud development or required CloudBase service is not enabled for the AppID.
- Collection permissions block the current mini program identity.

Fix path:

1. Verify `project.config.json` AppID.
2. In CloudBase console, check environment settings and app association for that AppID.
3. Recompile in WeChat Developer Tools after association changes.
4. If the error points to a collection read/write, inspect that collection's security rules.

### `database collection not exists` / `[ResourceNotFound] Db or Table not exist`

Likely causes:

- Code reads a collection that was never created, for example `storeConfig`.
- Admin and mini program use different names for the same concept.
- Data model generation expected a collection such as `shop_home_swiper_image`, but the actual app stores banner config elsewhere.

Fix path:

1. Search the repo for the exact collection name.
2. Decide whether the collection is truly part of the schema.
3. Create the collection and seed a minimal real document, or update code to read the actual existing collection.
4. Re-run the flow without mock data.

### Category or recommendation load failure

Typical visible messages include `获取分类列表失败` and `热门推荐加载失败`.

Check:

- Collection names for categories/products/recommendations.
- Published/status fields used by mini program filters.
- Required indexes or query order limitations.
- Permission rules for anonymous mini program reads.
- Whether the admin actually wrote data into the same environment.

Acceptance test:

1. Add a product in admin with category, price, image, stock, and published status.
2. Refresh the mini program home/category page.
3. Search the exact product name.
4. Open detail and verify price/image/category.

### Remote font errors

Examples:

- `Failed to load font https://cdn3.codesign.qq.com/... iconfont.woff`
- `Failed to load font https://tdesign.gtimg.com/icon/... t.woff`

Usually these are DevTools network/cache issues or third-party icon font access problems. They are not the same as product data failure. If icons are visibly broken in the customer experience, localize the font/icon assets or use bundled TDesign assets. Otherwise keep them as known DevTools warnings.

### `wx.getSystemInfoSync is deprecated`

This is a warning. Prefer modern APIs when touching the file:

- `wx.getWindowInfo()`
- `wx.getDeviceInfo()`
- `wx.getAppBaseInfo()`
- `wx.getSystemSetting()`
- `wx.getAppAuthorizeSetting()`

Do not block customer testing only because this warning appears.

### `Error: timeout` with only WeChat internal stack

When the stack only references files like `WAServiceMainContext...` and no project file, this is usually a WeChat Developer Tools/runtime renderer timeout, stale page stack, base library issue, or cache problem. It often appears after hot reloads or repeated recompiles.

Fix path:

1. Stop the current preview and recompile.
2. Close error dialogs and reload with Cmd+R.
3. Clear WeChat Developer Tools cache.
4. Quit and reopen WeChat Developer Tools.
5. If persistent, switch from grey/base test library to a stable base library version.
6. Only treat it as an app bug when a project file stack, reproducible UI action, or failed CloudBase request points to app code.

### `[worker] reportRealtimeAction:fail not support`

This is a DevTools capability warning. It is normally harmless and should not block delivery.

## Real Data Seeding Minimum

For an end-to-end trial, create or verify:

- `storeConfig`: store name, logo, phone, address, banner images, delivery settings.
- `categories`: at least one enabled category.
- `goods` or product collection: at least one published product with image, price, stock, category, and description.
- `coupons`: one test coupon if coupon flow is in scope.
- `orders`: created through the mini program order flow, not manually inserted, for order management testing.

Use the collection names in the actual codebase; the names above are examples.
