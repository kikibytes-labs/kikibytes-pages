const menuToggle = document.querySelector('.menu-toggle');
const siteMenu = document.querySelector('#site-menu');
const analyticsBeacon = document.querySelector('script[data-cf-beacon]');

if (!analyticsBeacon) {
  const beacon = document.createElement('script');
  beacon.type = 'module';
  beacon.src = 'https://static.cloudflareinsights.com/beacon.min.js';
  beacon.dataset.cfBeacon = '{"token":"06c2ec3d3f924d6f934940b80e9b656f"}';
  document.head.append(beacon);
}

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
