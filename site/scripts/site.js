document.documentElement.classList.remove('no-js');
document.documentElement.classList.add('js');

const menuToggle = document.querySelector('.menu-toggle');
const siteMenu = document.querySelector('#site-menu');
const reducedMotionQuery = window.matchMedia('(prefers-reduced-motion: reduce)');

const lightbox = document.querySelector('.lhb-lightbox');
const lightboxImage = lightbox?.querySelector('.lhb-lightbox-image');
const lightboxCaption = lightbox?.querySelector('#lhb-lightbox-caption');
const lightboxClose = lightbox?.querySelector('.lhb-lightbox-close');

if (
  lightbox
  && lightboxImage
  && lightboxCaption
  && lightboxClose
  && typeof lightbox.showModal === 'function'
) {
  document.querySelectorAll('.lhb-screenshot-link').forEach((link) => {
    link.addEventListener('click', (event) => {
      event.preventDefault();
      const image = link.querySelector('img');
      if (!image) return;

      lightboxImage.src = image.currentSrc || image.src;
      lightboxImage.alt = image.alt;
      lightboxImage.width = image.naturalWidth || Number(image.getAttribute('width'));
      lightboxImage.height = image.naturalHeight || Number(image.getAttribute('height'));
      lightboxCaption.textContent = link.closest('figure')?.querySelector('figcaption')?.textContent ?? '';
      lightbox.showModal();
    });
  });

  lightboxClose.addEventListener('click', () => lightbox.close());
  lightbox.addEventListener('click', (event) => {
    if (event.target === lightbox) lightbox.close();
  });
}

if (menuToggle && siteMenu) {
  const menuToggleLabel = menuToggle.querySelector('.sr-only');
  const setMenuOpen = (isOpen, restoreFocus = false) => {
    siteMenu.classList.toggle('is-open', isOpen);
    menuToggle.setAttribute('aria-expanded', String(isOpen));
    if (menuToggleLabel) {
      menuToggleLabel.textContent = isOpen ? 'Close navigation' : 'Open navigation';
    }
    if (restoreFocus) menuToggle.focus();
  };

  menuToggle.addEventListener('click', () => {
    setMenuOpen(!siteMenu.classList.contains('is-open'));
  });

  siteMenu.addEventListener('click', (event) => {
    if (!(event.target instanceof Element) || !event.target.closest('a')) return;
    setMenuOpen(false);
  });

  document.addEventListener('click', (event) => {
    if (!siteMenu.classList.contains('is-open') || !(event.target instanceof Node)) return;
    if (siteMenu.contains(event.target) || menuToggle.contains(event.target)) return;
    setMenuOpen(false);
  });

  document.addEventListener('keydown', (event) => {
    if (event.key !== 'Escape' || !siteMenu.classList.contains('is-open')) return;
    setMenuOpen(false, true);
  });

  window.matchMedia('(min-width: 801px)').addEventListener('change', (event) => {
    if (event.matches) setMenuOpen(false);
  });
}

document.querySelectorAll('a[href]').forEach((link) => {
  link.addEventListener('click', (event) => {
    if (
      event.defaultPrevented
      || event.button !== 0
      || event.metaKey
      || event.ctrlKey
      || event.shiftKey
      || event.altKey
      || link.hasAttribute('download')
      || reducedMotionQuery.matches
    ) return;
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
  loaderLabel.textContent = 'Loading KikiBytes Labs';
  siteLoader.append(loaderLabel);

  let loaderTimer;
  const showLoader = () => siteLoader.classList.add('is-visible');
  const dismissSiteLoader = () => {
    window.clearTimeout(loaderTimer);
    siteLoader.classList.add('is-hidden');
    siteLoader.classList.remove('is-visible');
    window.setTimeout(() => siteLoader.remove(), reducedMotionQuery.matches ? 0 : 260);
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
  const formStatus = contactForm.querySelector('.form-status');
  const honeypot = contactForm.querySelector('input[name="_honey"]');
  const cooldownMs = 60_000;
  const cooldownKey = 'kikibytes-contact-last-submission';

  if (submitButton && formStatus && honeypot) {
    contactForm.addEventListener('submit', async (event) => {
      event.preventDefault();
      if (submitButton.disabled || !contactForm.reportValidity()) return;

      // This browser-side cooldown improves the experience; it is not an abuse-prevention boundary.
      let lastSubmission = 0;
      try {
        lastSubmission = Number(window.localStorage.getItem(cooldownKey));
      } catch {
        // Private browsing or strict browser settings can block local storage.
      }
      const timeRemaining = cooldownMs - (Date.now() - lastSubmission);
      if (timeRemaining > 0) {
        formStatus.textContent = `Please wait ${Math.ceil(timeRemaining / 1000)} seconds before sending another message.`;
        return;
      }

      if (honeypot.value) {
        contactForm.reset();
        submitButton.disabled = true;
        submitButton.textContent = 'Message sent';
        formStatus.textContent = 'Thanks — your message was submitted to KikiBytes Labs.';
        return;
      }

      submitButton.disabled = true;
      submitButton.textContent = 'Sending…';
      formStatus.textContent = 'Sending your message…';

      const controller = new AbortController();
      const requestTimer = window.setTimeout(() => controller.abort(), 12_000);

      try {
        const response = await fetch('https://formsubmit.co/ajax/hello@kikibytes.com', {
          method: 'POST',
          headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
          body: JSON.stringify(Object.fromEntries(new FormData(contactForm))),
          signal: controller.signal,
        });
        const payload = await response.json();
        const submissionSucceeded = payload?.success === true || payload?.success === 'true';
        if (!response.ok || !submissionSucceeded) throw new Error('Form submission failed');

        try {
          window.localStorage.setItem(cooldownKey, String(Date.now()));
        } catch {
          // Submission succeeds even when the optional browser-side cooldown cannot persist.
        }
        contactForm.reset();
        submitButton.textContent = 'Message sent';
        formStatus.textContent = 'Thanks — your message was submitted to KikiBytes Labs.';
      } catch (error) {
        submitButton.disabled = false;
        submitButton.textContent = 'Send message →';
        formStatus.textContent = error?.name === 'AbortError'
          ? 'Sending timed out. Please try again, or email hello@kikibytes.com directly.'
          : 'We couldn’t send your message. Please try again, or email hello@kikibytes.com directly.';
      } finally {
        window.clearTimeout(requestTimer);
      }
    });
  }
}
