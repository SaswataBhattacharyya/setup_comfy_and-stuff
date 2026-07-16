Goal: Implement branded admin invoice PDF, order item image fallbacks, customer order action layout fix, and static cache headers.

Constraints:
- Keep existing checkout, cart, auth, payment, and Sendcloud behavior intact.
- Preserve the existing Sendcloud v3 label creation changes in backend/orders/services.py.
- Avoid adding dependencies.
- Make small, surgical changes.

Files touched:
- .opencode/state/current-task.md
- src/lib/orderItemMedia.ts
- src/pages/Orders.tsx
- src/pages/AdminHub.tsx
- backend/analytics/views.py
- deploy/nginx/solrasa.dev-proxy.conf.template

Completed items:
- Read current invoice PDF, order views, media helpers, and Nginx template.
- Added shared order item image resolver.
- Wired resolver into customer orders and admin order details.
- Fixed customer order Report/Rate action layout.
- Reworked admin order PDF generation into a branded Solrasa invoice.
- Added Nginx cache headers for index/fallback and JS/CSS assets.
- Generated a dummy invoice PDF at `plan/solrasa-dummy-invoice.pdf`.
- Added Sendcloud parcel ID display to customer order tracking.
- Clarified admin order shipment labels as Sendcloud parcel ID.

Remaining items:
- None.

Current build/lint/test status:
- `backend/.venv/bin/python -m py_compile backend/analytics/views.py backend/orders/services.py` passed.
- `backend/.venv/bin/python backend/manage.py check` passed.
- `npm run build` passed.
- PDF smoke test passed with fake order object and wrote `/tmp/solrasa-invoice-smoke.pdf`.
- Dummy PDF generated in `plan/solrasa-dummy-invoice.pdf`.
- `npm run test` passed.
- `npm run lint` failed on existing unrelated lint issues in `backend/.venv` vendored Django JS plus pre-existing UI lint rules.
- `graphify update .` passed with no topology changes.
- Follow-up `npm run build` passed after tracking UI label change.
- Final diff/status inspected.

Last error:
- `npm run lint` reports 32 errors/48 warnings unrelated to this change.

Next action:
- Report implementation summary and verification status to the user.
