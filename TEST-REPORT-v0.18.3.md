# Brick & Decor PWA v0.18.3 Test Report

## Scope
- Signed-copy RPC recovery
- Long quotation edit navigation / scroll retention
- Compact floating quotation scope editor
- Always-available Add Work Section / Area action

## Expected behaviour
1. `09_v0.18.3_restore_signed_copy_rpc.sql` creates/restores the signed-copy read RPCs.
2. Clicking an item Edit button does not leave the user at the top of a long quotation.
3. The editor is a compact viewport drawer with its own scrolling and sticky Save/Cancel actions.
4. Save/Cancel returns to the previous quotation scroll position.
5. `+ Add Work Section / Area` remains available as a floating action while reviewing a long quotation.
6. Existing v0.18.2 functionality is retained.
