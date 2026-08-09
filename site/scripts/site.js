const menuToggle = document.querySelector('.menu-toggle');
const siteMenu = document.querySelector('#site-menu');
const luckyHallDescription = 'A cozy bingo adventure with charming rooms, collectible lucky charms, satisfying level-ups, daily rewards, and a little bit of luck.';
const skitchDescription = 'Track your transit. Skitch keeps all your trip details organized in one place, so you can leave the spreadsheets behind.';

document.querySelectorAll('.project-card').forEach((card) => {
  const heading = card.querySelector('h2, h3');
  if (!heading) return;
  const description = heading.parentElement?.querySelector('p:not(.project-status)');
  if (!description) return;
  if (heading.textContent.trim() === 'Lucky Hall Bingo') description.textContent = luckyHallDescription;
  if (heading.textContent.trim() === 'Skitch') description.textContent = skitchDescription;
});

document.querySelectorAll('img[src*="assets/brand/logo.png"]').forEach((logo) => {
  logo.src = `${logo.src}?v=2`;
});

const homeAboutArt = document.querySelector('.about-preview .mascot-placeholder');
if (homeAboutArt) {
  const homeAboutImage = document.createElement('img');
  homeAboutImage.className = 'home-about-image';
  homeAboutImage.src = 'assets/projects/home-about.png';
  homeAboutImage.width = 1254;
  homeAboutImage.height = 1254;
  homeAboutImage.alt = 'KikiBytes Labs illustration';
  homeAboutArt.replaceWith(homeAboutImage);
}

if (document.querySelector('.hero-home')) document.body.classList.add('home-page');

if (menuToggle && siteMenu) {
  menuToggle.addEventListener('click', () => {
    const isOpen = siteMenu.classList.toggle('is-open');
    menuToggle.setAttribute('aria-expanded', String(isOpen));
    menuToggle.querySelector('.sr-only').textContent = isOpen ? 'Close navigation' : 'Open navigation';
  });

  siteMenu.addEventListener('click', (event) => {
    if (event.target.matches('a')) {
      siteMenu.classList.remove('is-open');
      menuToggle.setAttribute('aria-expanded', 'false');
      menuToggle.querySelector('.sr-only').textContent = 'Open navigation';
    }
  });
}

document.querySelectorAll('a[href]').forEach((link) => {
  link.addEventListener('click', (event) => {
    if (event.defaultPrevented || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
    if (link.target && link.target !== '_self') return;
    const url = new URL(link.href, window.location.href);
    if (url.origin !== window.location.origin || url.hash && url.pathname === window.location.pathname) return;
    event.preventDefault();
    document.body.classList.add('page-is-leaving');
    window.setTimeout(() => { window.location.href = url.href; }, 180);
  });
});

window.addEventListener('pageshow', () => {
  document.body.classList.remove('page-is-leaving');
});

document.querySelectorAll('.tag').forEach((tag) => {
  if (tag.textContent.trim() === 'Apple') tag.textContent = 'iOS';
});

document.querySelectorAll('.tag-list, .platform-list').forEach((list) => {
  const ios = [...list.children].find((tag) => tag.textContent.trim() === 'iOS');
  const android = [...list.children].find((tag) => tag.textContent.trim() === 'Android');
  if (ios && android) list.insertBefore(ios, android);
});

const appleTextWalker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
while (appleTextWalker.nextNode()) {
  appleTextWalker.currentNode.nodeValue = appleTextWalker.currentNode.nodeValue.replaceAll('Apple', 'iOS');
}
document.querySelectorAll('meta[content]').forEach((meta) => {
  meta.content = meta.content.replaceAll('Apple', 'iOS');
});

const skitchTags = document.querySelector('.project-card-skitch .tag-list');
if (skitchTags) skitchTags.innerHTML = '<span class="tag">iOS</span><span class="tag">Android</span>';

document.querySelectorAll('p').forEach((paragraph) => {
  if (paragraph.textContent.trim() === 'Our mission') {
    paragraph.nextElementSibling?.remove();
    paragraph.nextElementSibling?.remove();
    paragraph.remove();
  }
});

document.querySelectorAll('h2').forEach((heading) => {
  if (heading.textContent.trim() === 'Our values') heading.remove();
});

const projectGrid = document.querySelector('.project-grid');
if (projectGrid) {
  const title = document.createElement('div');
  title.className = 'projects-page-title';
  title.innerHTML = '<span aria-hidden="true">&lt;/&gt;</span><h2>Our projects</h2>';
  projectGrid.prepend(title);
  const skitchArt = projectGrid.querySelector('.project-card-skitch .project-card-art');
  if (skitchArt) skitchArt.innerHTML = '<img src="../assets/projects/skitch.png" width="1774" height="887" alt="Skitch transit trip tracking app artwork">';
  const projectsSection = projectGrid.closest('.section');
  if (projectsSection && !document.querySelector('.build-process-section')) {
    const processSection = document.createElement('section');
    processSection.className = 'section build-process-section';
    processSection.setAttribute('aria-labelledby', 'build-process-title');
    processSection.innerHTML = '<div class="container"><div class="section-title-label"><h2>How we build</h2></div><h2 id="build-process-title">Purposeful by process.</h2><p class="build-process-intro">We bring professional experience, curiosity, and care to every project, from the first idea to the finished experience.</p><div class="build-process-grid"><article class="build-process-step"><span class="build-process-icon" aria-hidden="true">⌕</span><h3>Discover</h3><p>We start with curiosity and real problems worth solving.</p></article><article class="build-process-step"><span class="build-process-icon" aria-hidden="true">✎</span><h3>Design</h3><p>Thoughtful, user-centered design guides every decision.</p></article><article class="build-process-step"><span class="build-process-icon" aria-hidden="true">⚙</span><h3>Build &amp; test</h3><p>Clean code, tested thoroughly, and built to last.</p></article><article class="build-process-step"><span class="build-process-icon" aria-hidden="true">↗</span><h3>Ship &amp; improve</h3><p>We launch, listen, and keep making things better.</p></article></div></div>';
    const processGrid = processSection.querySelector('.build-process-grid');
    const processLayout = document.createElement('div');
    processLayout.className = 'build-process-layout';
    const processArt = document.createElement('div');
    processArt.className = 'build-process-art';
    processArt.setAttribute('aria-hidden', 'true');
    processArt.innerHTML = '<img src="../assets/projects/build-process.png" width="1254" height="1254" alt="KikiBytes Labs build process artwork">';
    processGrid.replaceWith(processLayout);
    processLayout.append(processGrid, processArt);
    ['magnify.png', 'pencil.png', 'hammer.png', 'box.png'].forEach((filename, index) => {
      const icon = processGrid.querySelectorAll('.build-process-icon')[index];
      if (!icon) return;
      icon.innerHTML = `<img src="../assets/icons/${filename}" width="100" height="100" alt="">`;
    });
    projectsSection.insertAdjacentElement('afterend', processSection);
  }
}

const valuesGrid = document.querySelector('.value-grid');
if (valuesGrid && document.querySelector('.page-hero-art img[src*="about.png"]')) {
  const valuesLayout = document.createElement('div');
  valuesLayout.className = 'values-layout';
  const valuesArt = document.createElement('div');
  valuesArt.className = 'about-values-art';
  valuesArt.setAttribute('aria-hidden', 'true');
  valuesArt.innerHTML = '<img src="../assets/projects/about-values.png" width="509" height="490" alt="KikiBytes Labs illustration">';
  const valuesColumn = document.createElement('div');
  valuesColumn.className = 'values-cards-column';
  const valuesHeading = valuesGrid.parentNode.querySelector(':scope > .eyebrow');
  const valuesTitle = valuesHeading?.nextElementSibling;
  valuesGrid.parentNode.insertBefore(valuesLayout, valuesGrid);
  valuesLayout.append(valuesArt, valuesColumn);
  if (valuesHeading) valuesColumn.append(valuesHeading);
  if (valuesTitle) valuesColumn.append(valuesTitle);
  valuesColumn.append(valuesGrid);
  ['idea.png', 'ribbon.png', 'balloon.png', 'earth.png'].forEach((filename, index) => {
    const card = valuesGrid.querySelectorAll('.value-card')[index];
    if (!card) return;
    const image = document.createElement('img');
    image.className = 'value-card-icon';
    image.src = `../assets/icons/${filename}`;
    image.width = 100;
    image.height = 100;
    image.alt = '';
    card.prepend(image);
  });
  [
    ['Big ideas', 'We stay curious, explore new possibilities, and give good ideas room to grow.'],
    ['Quality standards', 'We bring professional standards, thoughtful details, and pride to everything we build.'],
    ['Pure joy', 'We believe the best software balances thoughtful design with creativity, warmth, and a little fun.'],
    ['People first', 'We care about our users, our communities, and the things we put into the world.'],
  ].forEach(([title, copy], index) => {
    const card = valuesGrid.querySelectorAll('.value-card')[index];
    if (!card) return;
    card.querySelector('h3').textContent = title;
    card.querySelector('p').textContent = copy;
  });
}

const lhbFeatureGrid = document.querySelector('.lhb-hero')?.closest('main')?.querySelector('.feature-grid');
const lhbHero = document.querySelector('.lhb-hero');
const lhbAboutCopy = lhbHero?.closest('main')?.querySelector('.content-section .prose');
if (lhbAboutCopy) {
  const lhbParagraphs = lhbAboutCopy.querySelectorAll(':scope > p');
  if (lhbParagraphs[1]) lhbParagraphs[1].textContent = 'Play at your own pace, choose your favorite color dauber, unlock specialty daub marks, and try your hand at pull tabs for surprise rewards.';
}
if (lhbHero && !document.querySelector('.lhb-launch')) {
  const launch = document.createElement('section');
  launch.className = 'section lhb-launch';
  launch.innerHTML = '<div class="container"><div class="lhb-launch-panel"><div><div class="section-title-label"><h2>Start playing</h2></div><h2 class="lhb-launch-name">Lucky Hall Bingo</h2></div><div class="lhb-launch-actions"><a class="button button-primary" href="https://luckyhallbingo.com" rel="noreferrer" target="_blank"><span class="platform-button-icon" aria-hidden="true">↗</span><span>Play<br>on Web</span></a><button class="button button-secondary" type="button" disabled><span class="platform-button-icon" aria-hidden="true">▣</span><span>Download<br>on iOS</span></button><button class="button button-secondary" type="button" disabled><span class="platform-button-icon" aria-hidden="true">▰</span><span>Download<br>on Android</span></button></div></div></div>';
  lhbHero.insertAdjacentElement('afterend', launch);
}
lhbHero?.closest('main')?.querySelector('.status-panel')?.closest('section')?.remove();

if (lhbFeatureGrid && lhbFeatureGrid.children.length === 4) {
  [
    ['daily-events.png', 'Daily & seasonal events', 'Fresh activities and themed moments to keep every visit feeling special.'],
    ['daily-rewards.webp', 'Daily rewards', 'Come back each day for bonuses, surprises, and a little extra luck.'],
    ['vip-perks.webp', 'VIP perks', 'Enjoy special benefits and thoughtful extras as you make Lucky Hall your own.'],
    ['level-up.webp', 'Level up', 'Level up to unlock themed rooms, charm mystery boxes, and new daubers.'],
  ].forEach(([image, title, copy]) => {
    const feature = document.createElement('article');
    feature.className = 'feature-card';
    feature.innerHTML = `<img src="../../assets/projects/lucky-hall/${image}" width="100" height="100" alt=""><h3>${title}</h3><p>${copy}</p>`;
    lhbFeatureGrid.append(feature);
  });

  const charmCard = [...lhbFeatureGrid.querySelectorAll('.feature-card')]
    .find((card) => card.querySelector('h3')?.textContent.trim() === 'Lucky charms');
  const dauberCard = [...lhbFeatureGrid.querySelectorAll('.feature-card')]
    .find((card) => card.querySelector('h3')?.textContent.trim() === 'Custom daubers');
  if (charmCard) charmCard.querySelector('p').textContent = 'Collect your favorite charms and level them up for higher coin bonuses.';
  if (dauberCard) {
    dauberCard.querySelector('h3').textContent = 'Colorful daubers';
    dauberCard.querySelector('p').textContent = 'Colorful daubers bring your bingo card to life with different daub mark shapes and XP bonuses.';
  }

  const classicCard = [...lhbFeatureGrid.querySelectorAll('.feature-card')]
    .find((card) => card.querySelector('h3')?.textContent.trim() === 'Classic bingo gameplay');
  const levelUpCard = [...lhbFeatureGrid.querySelectorAll('.feature-card')]
    .find((card) => card.querySelector('h3')?.textContent.trim() === 'Level up');
  if (classicCard && levelUpCard) classicCard.after(levelUpCard);

  const featureImages = {
    'Classic bingo gameplay': 'bingo.webp',
    'Lucky charms': 'lucky-charms.webp',
    'Colorful daubers': 'daubers.webp',
    'Pull tabs': 'pull-tabs.webp',
  };
  lhbFeatureGrid.querySelectorAll('.feature-card').forEach((card) => {
    const image = card.querySelector('img');
    if (!image) return;
    const filename = featureImages[card.querySelector('h3')?.textContent.trim()];
    if (!filename) return;
    image.src = `../../assets/projects/lucky-hall/${filename}`;
    image.width = 100;
    image.height = 100;
    image.alt = '';
  });
}

const mainContent = document.querySelector('main');
const isAboutOrProjects = document.querySelector('img[src*="../assets/banners/about.png"]') || projectGrid;
if (mainContent && isAboutOrProjects && !document.querySelector('.home-cta')) {
  const cta = document.createElement('section');
  cta.className = 'section home-cta';
  cta.innerHTML = '<div class="container home-cta-inner"><div><p class="section-title-label">Keep in touch</p><h2>Have a question? Let’s talk.</h2><p>We’d love to hear what you think about KikiBytes Labs and the projects we’re building.</p></div><a class="button button-primary" href="../contact/">Get in touch <span aria-hidden="true">→</span></a></div>';
  mainContent.append(cta);
}

const contactDetails = document.querySelector('.contact-details');
if (contactDetails) {
  contactDetails.querySelector('.section-title-label')?.remove();
  const contactHeading = contactDetails.querySelector('h2');
  if (contactHeading) contactHeading.textContent = 'Reach the lab.';
  const contactIntro = [...contactDetails.querySelectorAll(':scope > p')]
    .find((paragraph) => paragraph.textContent.includes('Have a question or feedback'));
  if (contactIntro) contactDetails.insertBefore(contactIntro, contactDetails.querySelector(':scope > p'));
  if (!contactDetails.querySelector('.contact-values-art')) {
    const contactArt = document.createElement('div');
    contactArt.className = 'contact-values-art';
    contactArt.setAttribute('aria-hidden', 'true');
    contactArt.innerHTML = '<img src="../assets/projects/contact.png" width="1536" height="1024" alt="KikiBytes Labs contact illustration">';
    contactDetails.append(contactArt);
  }
}

const legalCopy = document.querySelector('.legal-copy');
if (legalCopy) {
  const legalTitle = document.createElement('div');
  legalTitle.className = 'section-title-label';
  legalTitle.innerHTML = `<h2>${document.title.split(' — ')[0]}</h2>`;
  legalCopy.prepend(legalTitle);
}

const aboutIntro = document.querySelector('.page-hero-art img[src*="../assets/banners/about.png"]')?.closest('main')?.querySelector('.content-section .prose');
if (aboutIntro) {
  const introHeading = aboutIntro.querySelector('h2');
  const introParagraphs = aboutIntro.querySelectorAll(':scope > p:not(.eyebrow)');
  if (introHeading) introHeading.textContent = 'Professional builders by day. Curious creators by night.';
  if (introParagraphs[0]) introParagraphs[0].textContent = 'KikiBytes Labs grew from a simple habit: after years of building production systems and applications professionally, we kept coming home with more ideas we wanted to bring to life.';
  if (introParagraphs[1]) introParagraphs[1].textContent = 'By day, we design, engineer, and support software that needs to be reliable, maintainable, and useful. By night, we bring that same care and experience to apps and games with more room for experimentation, personality, and play.';
}

const footerLegal = document.querySelector('.footer-legal');
const footerLinks = document.querySelector('.footer-links');
if (footerLegal && footerLinks) {
  footerLinks.append(...footerLegal.querySelectorAll('a'));
  footerLegal.remove();
}

const contactForm = document.querySelector('.contact-form');
if (contactForm) {
  const submitButton = contactForm.querySelector('button[type="submit"]');
  const formNote = contactForm.querySelector('.form-note');
  if (submitButton) submitButton.innerHTML = 'Send message <span aria-hidden="true">→</span>';
  if (formNote) formNote.textContent = 'Your message will be sent directly to KikiBytes Labs.';
  contactForm.addEventListener('submit', async (event) => {
    event.preventDefault();
    if (!contactForm.reportValidity()) return;
    submitButton.disabled = true;
    submitButton.textContent = 'Sending…';
    try {
      const response = await fetch('https://formsubmit.co/ajax/hello@kikibytes.com', {
        method: 'POST',
        headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
        body: JSON.stringify(Object.fromEntries(new FormData(contactForm))),
      });
      if (!response.ok) throw new Error('Form submission failed');
      contactForm.reset();
      submitButton.textContent = 'Message sent';
      if (formNote) formNote.textContent = 'Thanks — your message was sent to KikiBytes Labs.';
    } catch (_) {
      submitButton.disabled = false;
      submitButton.innerHTML = 'Send message <span aria-hidden="true">→</span>';
      if (formNote) formNote.innerHTML = 'We couldn’t send the form. Email <a href="mailto:hello@kikibytes.com">hello@kikibytes.com</a> directly.';
    }
  });
}
