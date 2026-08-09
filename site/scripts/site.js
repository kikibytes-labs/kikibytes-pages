const menuToggle = document.querySelector('.menu-toggle');
const siteMenu = document.querySelector('#site-menu');
const analyticsBeacon = document.querySelector('script[data-cf-beacon]');
const featuredProjectArt = document.querySelector('.project-card-art-lhb img');

if (featuredProjectArt) {
  featuredProjectArt.removeAttribute('loading');
  featuredProjectArt.fetchPriority = 'high';
}

if (!analyticsBeacon) {
  const beacon = document.createElement('script');
  beacon.type = 'module';
  beacon.src = 'https://static.cloudflareinsights.com/beacon.min.js';
  beacon.dataset.cfBeacon = '{"token":"06c2ec3d3f924d6f934940b80e9b656f"}';
  document.head.append(beacon);
}

document.querySelectorAll('.site-footer .footer-grid').forEach((footerGrid) => {
  if (footerGrid.children.length !== 2) return;

  const connect = document.createElement('div');
  const heading = document.createElement('h2');
  heading.className = 'footer-heading';
  heading.textContent = 'Connect';
  const links = document.createElement('div');
  links.className = 'social-links';

  [
    ['Instagram', 'https://instagram.com/kikibytes'],
    ['Facebook', 'https://www.facebook.com/profile.php?id=61588637222576'],
    ['hello@kikibytes.com', 'mailto:hello@kikibytes.com'],
  ].forEach(([label, href]) => {
    const link = document.createElement('a');
    link.href = href;
    link.textContent = label;
    if (href.startsWith('https://')) link.rel = 'noreferrer';
    links.append(link);
  });

  connect.append(heading, links);
  footerGrid.append(connect);
});

const socialIcons = {
  Instagram: '/assets/icons/instagram.webp',
  Facebook: '/assets/icons/facebook.webp',
  'hello@kikibytes.com': '/assets/icons/email.webp',
};

document.querySelectorAll('.social-links a').forEach((link) => {
  const iconSource = socialIcons[link.textContent.trim()];
  if (!iconSource) return;

  const image = document.createElement('img');
  image.src = iconSource;
  image.width = 28;
  image.height = 28;
  image.alt = '';
  link.classList.add('social-icon-link');
  link.setAttribute('aria-label', link.textContent.trim());
  link.replaceChildren(image);
});

if (menuToggle && siteMenu) {
  menuToggle.addEventListener('click', () => {
    const isOpen = siteMenu.classList.toggle('is-open');
    menuToggle.setAttribute('aria-expanded', String(isOpen));
    menuToggle.querySelector('.sr-only').textContent = isOpen ? 'Close navigation' : 'Open navigation';
  });

  siteMenu.addEventListener('click', (event) => {
    if (!event.target.matches('a')) return;
    siteMenu.classList.remove('is-open');
    menuToggle.setAttribute('aria-expanded', 'false');
    menuToggle.querySelector('.sr-only').textContent = 'Open navigation';
  });
}

document.querySelectorAll('a[href]').forEach((link) => {
  link.addEventListener('click', (event) => {
    if (event.defaultPrevented || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
    if (link.target && link.target !== '_self') return;

    const url = new URL(link.href, window.location.href);
    if (url.origin !== window.location.origin || (url.hash && url.pathname === window.location.pathname)) return;

    event.preventDefault();
    document.body.classList.add('page-is-leaving');
    window.setTimeout(() => { window.location.href = url.href; }, 180);
  });
});

window.addEventListener('pageshow', () => {
  document.body.classList.remove('page-is-leaving');
});

const siteLoader = document.querySelector('.site-loader');
if (siteLoader) {
  const loaderLabel = document.createElement('span');
  loaderLabel.textContent = 'Loading KikiBytes.com';
  siteLoader.append(loaderLabel);

  let loaderTimer;
  const showLoader = () => siteLoader.classList.add('is-visible');
  const dismissSiteLoader = () => {
    window.clearTimeout(loaderTimer);
    siteLoader.classList.add('is-hidden');
    siteLoader.classList.remove('is-visible');
    window.setTimeout(() => siteLoader.remove(), 260);
  };

  if (document.readyState === 'complete') dismissSiteLoader();
  else {
    loaderTimer = window.setTimeout(showLoader, 450);
    window.addEventListener('load', dismissSiteLoader, { once: true });
  }
}

const contactForm = document.querySelector('.contact-form');
if (contactForm) {
  const submitButton = contactForm.querySelector('button[type="submit"]');
  const formNote = contactForm.querySelector('.form-note');
  const cooldownMs = 60_000;
  const cooldownKey = 'kikibytes-contact-last-submission';
  const honeypot = document.createElement('input');
  honeypot.className = 'form-honeypot';
  honeypot.name = '_honey';
  honeypot.tabIndex = -1;
  honeypot.autocomplete = 'off';
  honeypot.setAttribute('aria-hidden', 'true');
  contactForm.prepend(honeypot);

  submitButton.textContent = 'Send message →';
  formNote.textContent = 'Your message will be sent directly to KikiBytes Labs.';
  formNote.setAttribute('aria-live', 'polite');

  contactForm.addEventListener('submit', async (event) => {
    event.preventDefault();
    if (!contactForm.reportValidity()) return;

    let lastSubmission = 0;
    try {
      lastSubmission = Number(window.localStorage.getItem(cooldownKey));
    } catch {
      // Private browsing or strict browser settings can block local storage.
    }
    const timeRemaining = cooldownMs - (Date.now() - lastSubmission);
    if (timeRemaining > 0) {
      formNote.textContent = `Please wait ${Math.ceil(timeRemaining / 1000)} seconds before sending another message.`;
      return;
    }

    if (honeypot.value) {
      contactForm.reset();
      submitButton.textContent = 'Message sent';
      formNote.textContent = 'Thanks — your message was sent to KikiBytes Labs.';
      return;
    }

    submitButton.disabled = true;
    submitButton.textContent = 'Sending…';

    try {
      const response = await fetch('https://formsubmit.co/ajax/hello@kikibytes.com', {
        method: 'POST',
        headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
        body: JSON.stringify(Object.fromEntries(new FormData(contactForm))),
      });
      if (!response.ok) throw new Error('Form submission failed');

      try {
        window.localStorage.setItem(cooldownKey, String(Date.now()));
      } catch {
        // Submission succeeds even when the optional browser-side cooldown cannot persist.
      }
      contactForm.reset();
      submitButton.textContent = 'Message sent';
      formNote.textContent = 'Thanks — your message was sent to KikiBytes Labs.';
    } catch {
      submitButton.disabled = false;
      submitButton.textContent = 'Send message →';
      formNote.textContent = 'We couldn’t send your message. Please email hello@kikibytes.com directly.';
    }
  });
}
