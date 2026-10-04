# Wavely Campaigns

Wavely is a local, consent-first WhatsApp campaign dashboard that sends text through the unofficial [MudBot](https://github.com/pocha/mudbot) API. Every user runs Wavely on their own Windows PC; credentials and contacts remain local.

> MudBot warns that unofficial automation may violate WhatsApp's terms and can cause restrictions or bans. No sending volume is guaranteed safe. Message only people who explicitly opted in and honor every opt-out immediately.

## Start here — a very simple explanation

You do **not** need to be a programmer to use Wavely. Think of the system as four separate things:

1. **WhatsApp on your phone** is the account that actually sends the messages.
2. **MudBot** is the delivery helper. You connect it to WhatsApp by scanning a square QR picture.
3. **Wavely** is the control panel on your computer. It reads your list and asks MudBot to send each message.
4. **The CSV file** is the address book. It contains phone numbers and country codes.

Wavely does not live on a public website. It runs only on your computer. When this guide says “server,” it simply means the small Wavely program running in the black/blue PowerShell window. Keep that window open while using Wavely.

An **API key** is a private password that lets Wavely speak to your MudBot account. Do not send it to anyone, photograph it, or paste it into WhatsApp. Each person using Wavely needs their own key.

### The whole process in plain words

Do these jobs in this order:

1. Connect MudBot to WhatsApp and get its API key.
2. Download and extract Wavely.
3. Run one setup command. It installs Node.js if needed and starts Wavely.
4. Import a CSV list.
5. Send one test message.
6. Only after the test works, start the campaign.

The detailed instructions below explain every step.

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

## 0. Easy setup: use one command

Node.js is the free engine that makes Wavely run. You do not need to install it by hand. The included helper can install it for you.

First complete the MudBot connection in section 1 and download Wavely as explained in section 2. Then:

1. Open the extracted `wavely-campaigns` folder.
2. Click the address box at the top of the folder window.
3. Type `powershell` and press **Enter**. A blue or black window opens.
4. Copy the entire command below, paste it into that window, and press **Enter**:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup-and-start.ps1
```

5. If Windows asks for permission to install Node.js, select **Yes**.
6. When asked for the MudBot API key, paste it and press **Enter**. Nothing appears while it is pasted; that is intentional so nearby people cannot read the private key.
7. Wait. The browser opens Wavely automatically.
8. Keep the PowerShell window open while using Wavely. Press **Ctrl+C** in that window when completely finished.

The helper does these jobs automatically:

- Checks whether Node.js is already installed.
- Installs the current free Node.js LTS release through Windows Package Manager when necessary.
- Saves the MudBot key in the private `.env` file only when that file does not already exist.
- Keeps an existing `.env` file unchanged.
- Opens `http://127.0.0.1:3000` and starts Wavely.

If it says that Windows must restart, restart the computer, return to the extracted folder, and run the same command again. Node.js only needs to be installed once.

You only install Node.js once. If someone already installed it, skip this section.

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

For a non-technical user, use the ZIP method:

1. On this GitHub page, find the green **Code** button near the top.
2. Select **Code**.
3. Select **Download ZIP**.
4. Open the computer's **Downloads** folder.
5. Right-click the downloaded ZIP file.
6. Select **Extract All**.
7. Select **Extract**.
8. Move the extracted folder somewhere easy to find, such as **Documents**.

Do not run Wavely from inside the ZIP file. It must be extracted first.

The following clone commands are only for developers:

```powershell
git clone <repository-url>
cd wavely-campaigns
```

The one-command setup creates the private settings file automatically. The manual instructions below are only needed if the automatic helper cannot be used:

1. Open the extracted Wavely folder.
2. Find `.env.example`. If Windows hides file endings, open File Explorer's **View** menu and enable **File name extensions**.
3. Right-click `.env.example` and select **Copy**.
4. Right-click an empty area in the same folder and select **Paste**.
5. Rename the copy to exactly `.env`.
6. If Windows warns about changing a file extension, select **Yes**.
7. Right-click `.env` and open it with **Notepad**.
8. Replace only `paste_your_private_key_here` with the key copied from MudBot.
9. Do not add spaces before or after the key.
10. Select **File → Save**, then close Notepad.

The finished file should look like this, except it will contain the user's real private key:

```env
MUDBOT_API_KEY=paste_your_private_key_here
MUDBOT_BASE_URL=https://api.watobot.xyz
PORT=3000
```

Never put a key in `app.js`, a CSV, screenshots, support messages, or commits. Every user must use their own MudBot account, linked WhatsApp device, and API key.

## 3. Start Wavely on later days

The simplest method is to repeat the same command whenever you want to use Wavely:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup-and-start.ps1
```

It will see that Node.js and `.env` already exist, keep them unchanged, and start the program. Alternatively, start it manually as follows:

1. Open the extracted Wavely folder in File Explorer.
2. Click once inside the address bar at the top of File Explorer. This is the box showing the folder location.
3. Type `powershell` and press **Enter**.
4. A blue or black PowerShell window opens in the correct folder.
5. Type the command below exactly and press **Enter**:

```powershell
npm.cmd start
```

Wait until PowerShell displays `Wavely: http://127.0.0.1:3000`.

Then:

1. Leave PowerShell open.
2. Open Chrome, Edge, or Firefox.
3. Type `http://127.0.0.1:3000` into the browser's address bar.
4. Press **Enter**.

Keep PowerShell open; closing it stops Wavely and any campaign. You may minimize it, but do not close it until sending is finished. Wavely binds only to `127.0.0.1`, so other computers cannot access this instance.

To stop Wavely after all work is finished, click the PowerShell window, hold **Ctrl**, and press **C** once.

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

### Making the CSV in Excel

1. Open Excel and create a blank workbook.
2. In cell **A1**, type `phone`.
3. In cell **B1**, type `country_code`.
4. Starting in row 2, put one phone number in column A and its country code in column B.
5. Do not type a `+` sign, spaces, brackets, or hyphens.
6. Select **File → Save As**.
7. Choose an easy location such as Desktop.
8. In **Save as type**, choose **CSV UTF-8 (Comma delimited) (*.csv)**.
9. Give the file a clear name such as `customers.csv`.
10. Select **Save**. If Excel warns that CSV supports only one sheet, choose to continue.

Before importing, open the file once and confirm the first row says `phone,country_code`.

## 5. Import and test

1. Open **Contacts**.
2. Select **Import CSV** or drag the file onto the drop zone.
3. Review the table and recipient count.
4. Open **New campaign**.
5. Enter a campaign name and message.
6. Check the consent statement only after verifying every recipient opted in.
7. Select **Send one test** and confirm the first recipient.
8. Verify delivery. Do not launch if the test fails.

The test uses the first phone number in the imported CSV. If possible, make that first number your own phone or a colleague's opted-in test number.

**Clear all contacts** deletes the local list after confirmation and is disabled during campaigns.

## 6. Launch and monitor

1. After a successful test, select **Review & launch**.
2. Verify the exact message and count.
3. Select **Launch campaign**.
4. Open **Activity** and keep Wavely running.

Activity shows processed, successful, failed, and percentage complete. **Stop campaign** prevents another recipient from starting after the active request finishes. **Clear activity** removes memory-only history when no campaign is active.

“Sent” means MudBot reported success. It does not guarantee that the recipient read the message. “Failed” means the request did not complete; inspect the error before trying again so you do not accidentally duplicate successful messages.

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
