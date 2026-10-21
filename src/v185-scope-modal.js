/* Brick & Decor PWA v0.18.5 — presentation-only modal enhancement.
   The existing v0.18.4 quotation editor/validator/save handlers are untouched. */
(function () {
  'use strict';
  const HOST_ID = 'v182_scope_host';
  let activeHost = null;
  let opener = null;
  let oldOverflow = '';
  let oldPaddingRight = '';

  function expandServiceWording(host) {
    // Keep the original IDs and inline handlers. All existing Supabase/service
    // filtering and saving code reads .value, which works for textarea too.
    host.querySelectorAll('.v182ServiceField input[id^="v182_item_"]').forEach(input => {
      const focused = document.activeElement === input;
      const area = document.createElement('textarea');
      Array.from(input.attributes).forEach(attr => {
        if (attr.name !== 'value' && attr.name !== 'type') {
          area.setAttribute(attr.name, attr.value);
        }
      });
      area.rows = 2;
      area.value = input.value;
      input.replaceWith(area);
      if (focused) {
        area.focus({ preventScroll: true });
      }
    });
  }

  function activate(host) {
    activeHost = host;
    opener = document.activeElement;
    const root = document.documentElement;
    oldOverflow = root.style.overflow;
    oldPaddingRight = root.style.paddingRight;
    const gutter = Math.max(0, window.innerWidth - root.clientWidth);
    if (gutter) root.style.paddingRight = gutter + 'px';
    root.style.overflow = 'hidden';

    const dialog = host.querySelector('#v182_scope_editor');
    if (dialog) {
      dialog.setAttribute('role', 'dialog');
      dialog.setAttribute('aria-modal', 'true');
      const heading = dialog.querySelector('h2');
      if (heading) {
        heading.id = 'v185_scope_heading';
        dialog.setAttribute('aria-labelledby', heading.id);
      }
      const close = dialog.querySelector('.sectionToolbar > button');
      if (close) close.setAttribute('aria-label', 'Close quotation editor');
      const first = dialog.querySelector('#v182_section');
      if (first) first.focus({ preventScroll: true });
    }
  }

  function deactivate() {
    const root = document.documentElement;
    root.style.overflow = oldOverflow;
    root.style.paddingRight = oldPaddingRight;
    activeHost = null;
    if (opener && opener.isConnected) {
      try { opener.focus({ preventScroll: true }); } catch (_) { /* stale opener */ }
    }
    opener = null;
  }

  function synchronize() {
    const host = document.getElementById(HOST_ID);
    if (!host) {
      if (activeHost) deactivate();
      return;
    }
    // Portaling the modal to <body> ensures position:fixed remains viewport-
    // relative and avoids destroying unsaved form inputs during quotation redraws.
    if (host.parentNode !== document.body) document.body.appendChild(host);
    const dialog = host.querySelector('#v182_scope_editor');
    if (!dialog) return;
    // v0.18.2 may recreate an obsolete inline editor during a quote redraw;
    // remove that duplicate so ID-based save handlers always use THIS modal.
    document.querySelectorAll('#v182_scope_editor').forEach(node => {
      if (node !== dialog) node.remove();
    });
    if (activeHost !== host) {
      if (activeHost) deactivate();
      activate(host);
    }
    expandServiceWording(host);
  }

  document.addEventListener('click', e => {
    if (e.target && e.target.id === HOST_ID && typeof window.v182CancelScope === 'function') {
      window.v182CancelScope();
    }
  });

  document.addEventListener('keydown', e => {
    if (!activeHost || e.key !== 'Tab') return;
    const elements = Array.from(activeHost.querySelectorAll(
      'button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'
    )).filter(el => el.getClientRects().length);
    if (!elements.length) return;
    const first = elements[0];
    const last = elements[elements.length - 1];
    if (e.shiftKey && (document.activeElement === first || !activeHost.contains(document.activeElement))) {
      e.preventDefault(); last.focus({ preventScroll: true });
    } else if (!e.shiftKey && (document.activeElement === last || !activeHost.contains(document.activeElement))) {
      e.preventDefault(); first.focus({ preventScroll: true });
    }
  });

  const observe = new MutationObserver(synchronize);
  observe.observe(document.body, { childList: true, subtree: true });
  synchronize();
})();
