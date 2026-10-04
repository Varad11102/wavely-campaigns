# Wavely Campaigns

Wavely is a local, consent-first WhatsApp campaign dashboard that sends text through the unofficial [MudBot](https://github.com/pocha/mudbot) API. Every user runs Wavely on their own Windows PC; credentials and contacts remain local.

> MudBot warns that unofficial automation may violate WhatsApp's terms and can cause restrictions or bans. No sending volume is guaranteed safe. Message only people who explicitly opted in and honor every opt-out immediately.

## Features

- Local dashboard at `http://127.0.0.1:3000`
- CSV import, validation, duplicate removal, and search (maximum 1,000 rows)
- Single-recipient test and sequential campaigns
- Live processed/sent/failed counts, stop control, and session activity
- Clear contacts and clear activity controls
- API key stays server-side and is never delivered to browser JavaScript

## Limitations

- Text only. MudBot's `media` field expects a path on its remote server and the hosted API has no upload endpoint, so a user's local image/video/audio/document cannot currently be sent.
- Activity is memory-only and resets when Wavely restarts.
- Wavely must remain running until a campaign ends.
- MudBot test keys normally expire after one hour unless its server owner marks one permanent.
- MudBot operations can take approximately 15–20 seconds.
- The 1,000-row CSV capacity is not a promise that sending 1,000 messages is safe.

## Requirements

- Windows 10/11
- [Node.js 18+](https://nodejs.org/)
- A browser
- Internet access
- A MudBot account, connected WhatsApp device, and valid API key

## 1. Configure MudBot

1. Open <https://watobot.xyz>.
2. Register/sign in through MudBot's email magic-link flow.
3. Open its dashboard and select **Connect WhatsApp**.
4. On the phone, open WhatsApp/WhatsApp Business and go to **Settings/Menu → Linked devices → Link a device**.
5. Scan MudBot's QR code and wait until it reports that WhatsApp is connected. Its documentation notes this can require several attempts.
6. Open MudBot's API-key section and generate a key.
7. Copy it immediately and keep it private.

Generated keys are documented as one-hour test keys. Only the MudBot server owner can mark one permanent; Wavely cannot extend it.

MudBot's hosted backend is:

```text
https://api.watobot.xyz
```

Do not configure `https://watobot.xyz`; that is the website, not the API.

## 2. Download and configure Wavely

Download the repository ZIP and extract it, or clone it:

```powershell
git clone <repository-url>
cd wavely-campaigns
```

Copy `.env.example` to `.env`, then edit `.env`:

```env
MUDBOT_API_KEY=paste_your_private_key_here
MUDBOT_BASE_URL=https://api.watobot.xyz
PORT=3000
```

Never put a key in `app.js`, a CSV, screenshots, support messages, or commits. Every user must use their own MudBot account, linked WhatsApp device, and API key.

## 3. Start Wavely

Open PowerShell in the project folder:

```powershell
npm.cmd start
```

Open <http://127.0.0.1:3000>. Keep PowerShell open; closing it stops Wavely and any campaign. Wavely binds only to `127.0.0.1`, so other computers cannot access that instance.

## 4. Create the CSV

The file must contain exactly:

```csv
phone,country_code
9000000001,91
9000000002,91
```

- Use the national number in `phone`, digits only.
- Use a digits-only country code without `+`; India is `91`.
- Do not add names or other personal data.
- Use 1–1,000 opted-in recipients.
- Duplicate normalized numbers are removed automatically.

The real `contacts.csv` is Git-ignored to protect recipients. `contacts.example.csv` is a blank template.

## 5. Import and test

1. Open **Contacts**.
2. Select **Import CSV** or drag the file onto the drop zone.
3. Review the table and recipient count.
4. Open **New campaign**.
5. Enter a campaign name and message.
6. Check the consent statement only after verifying every recipient opted in.
7. Select **Send one test** and confirm the first recipient.
8. Verify delivery. Do not launch if the test fails.

**Clear all contacts** deletes the local list after confirmation and is disabled during campaigns.

## 6. Launch and monitor

1. After a successful test, select **Review & launch**.
2. Verify the exact message and count.
3. Select **Launch campaign**.
4. Open **Activity** and keep Wavely running.

Activity shows processed, successful, failed, and percentage complete. **Stop campaign** prevents another recipient from starting after the active request finishes. **Clear activity** removes memory-only history when no campaign is active.

## Responsible operation

- Use only numbers supplied directly by recipients who explicitly opted in to this business on WhatsApp.
- Send only message categories they agreed to receive.
- Identify the business and purpose clearly.
- Include an opt-out such as `Reply STOP to unsubscribe` and remove opt-outs before the next campaign.
- Never use purchased, scraped, generated, or third-party lists.
- For official limits, templates, media, and lower policy risk, use Meta's official WhatsApp Business Platform instead.

## Troubleshooting

### `fetch failed`

Ensure `.env` uses `MUDBOT_BASE_URL=https://api.watobot.xyz`. Check internet, firewall, proxy, and DNS access.

### Invalid or expired key

Generate a fresh key in MudBot, replace `MUDBOT_API_KEY`, stop Wavely with `Ctrl+C`, and run `npm.cmd start` again.

### WhatsApp not connected

Reconnect from MudBot using WhatsApp **Linked devices**, wait for confirmation, then send one test.

### `EADDRINUSE` on port 3000

An instance is already running. Use it, close its terminal with `Ctrl+C`, or change `PORT` in `.env`.

### Old interface appears

Refresh twice or clear site data for `127.0.0.1`. The service worker prefers the server version and falls back to cache offline.

### CSV rejected

Use the exact `phone,country_code` header, digits only, valid country codes, and no more than 1,000 rows.

## Development and security

No third-party npm packages are required.

```powershell
npm.cmd run check
npm.cmd start
```

- `server.js`: local server, MudBot client, contacts, campaign queue
- `app.js`: dashboard and CSV parsing
- `index.html` / `styles.css`: interface
- `.env.example`: safe configuration template

`.env` and `contacts.csv` are ignored. The API key and message content are transmitted only to the configured MudBot server during sends. Activity is not written to disk.

## License

No license is currently granted. All rights reserved.
