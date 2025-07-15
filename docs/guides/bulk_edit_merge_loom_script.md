# Loom Demo Script – Bulk-edit & Merge

*Recording length target: **≤ 2 min***

---

## 0. Setup
1. Start local dev server `flutter run -d chrome`.
2. Prepare `players_bulk_10k.csv` (use template + duplicates).

## 1. Import preview
1. Navigate to **Spelers** screen.
2. Click **Upload** → choose `players_bulk_10k.csv`.
3. Mention streaming preview (< 1 s for 10 000 rows).

## 2. Bulk-edit
1. Select first 50 rows (⇧-click).
2. Edit *Positie* cell → type “Middenvelder”.
3. Show inline validation + instant update.

## 3. Duplicate merge
1. Click **Importeren**.
2. Duplicate dialog appears – pick different values (show radio buttons).
3. Click **Opslaan**.

## 4. Undo / rollback
1. Snackbar shows successful import + **Undo** button.
2. Click **Undo** – confirm players list count decreases.

## 5. Call-to-action
*Wrap-up message: “Bulk-edit & Merge – now live!”*

---

### Recording checklist
- Browser zoom 90 % (visibility)
- Hide sensitive data (emails, …)
- Use dark mode UI theme for contrast

---

### Loom link placeholder
Once recorded, replace the link in `import_guide.md`:

```
https://loom.com/share/<new-id>
```