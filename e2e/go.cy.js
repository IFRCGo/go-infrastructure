/// <reference types="cypress" />
// https://docs.cypress.io/examples/examples/tutorials#Best-Practices
// https://docs.cypress.io/api/cypress-api/cookies#Preserve-Once ! Log in only once
// https://glebbahmutov.com/blog/keep-passwords-secret-in-e2e-tests/
// https://example.cypress.io/commands/waiting
// https://github.com/cypress-io/cypress-realworld-app | https://www.cypress.io/blog/2020/06/11/introducing-the-cypress-real-world-app/
// https://www.cypress.io/blog/2019/05/02/run-cypress-with-a-single-docker-command/

import { login, loginUI, loginHere, urlExists } from '../../support/e2e.js'

context('Actions', () => {
  beforeEach(() => {
    Cypress.Cookies.preserveOnce('sessionid, csrftoken, UILanguage')
  })
  // resizeobserver loop limit exceeded (can be Chrome related)
  // https://stackoverflow.com/questions/53845493/cypress-uncaught-assertion-error-despite-cy-onuncaughtexception
  Cypress.on('uncaught:exception', (err, runnable) => {
    return false;
  });

  it('checks recover-account', () => {
    cy.visit('http://localhost:3000/recover-account')
    cy.contains('.inpage__title', 'Recover Account')
  })

  it('checks a 3W endpoint', () => {
    cy.visit('http://localhost:3000/three-w')
    cy.contains('.styles_heading__2SPPb', 'Global 3W Response')
    cy.contains(':nth-child(2) > .styles_title__1rd77', 'Programme Type')
//    cy.get(':nth-child(3) > [href="/about"] > span').click()
//    cy.contains('.about__resources__block > .container-lg > div.text-center > .line-brand-deco-border-top-wrap > .fold__title > span', 'IFRC Resources')

    cy.get('.nav-global-menu > :nth-child(2) > .drop__toggle--caret > span').click() // Regions
    cy.get(':nth-child(4) > .drop__menu-item').click() // Europe
    cy.get('.link--with-icon-text').click() // All countries
    cy.get(':nth-child(1) > .region-countries__link > .region-countries__linkC').click() // First one
    //cy.get('a[href="/foo"]').should('have.attr', 'target', '_blank')
    cy.get(':nth-child(1) > .pill__brand').then(($el)=>{
      //$el.get(0).click();
      //console.log("this is it!")
      //debugger
      //console.log($el[0].href)
      expect($el[0].href).to.be.eq("https://www.ifrc.org/national-societies-directory/albanian-red-cross")
      urlExists($el[0].href, function(exists) { cy.expect(exists).to.be.true; });
    })
    cy.get('.nav-global-menu > :nth-child(2) > .drop__toggle--caret > span').click() // Regions
    cy.get(':nth-child(4) > .drop__menu-item').click() // Europe
    cy.get('.link--with-icon-text').click() // All countries
    cy.get(':nth-child(2) > .region-countries__link > .region-countries__linkC').click() // First one


    //cy.contains('#ns-data-wrapper > div.ns-directory-header > div > div.col-4.page-hero__title-block > h2','Albanian Red Cross')

  })

  it('logs in via UI', () => {
    loginUI()
//    cy.contains('.page__meta-nav > .drop__toggle > span', 'test user')
    cy.contains('.page__meta-nav > .drop__toggle > span', 'Levente Otta')
    cy.get('.nav-global-menu > :nth-child(2) > .drop__toggle--caret > span').click()
    cy.get(':nth-child(4) > .drop__menu-item').click()
    cy.contains('.inpage__title', 'Europe')
    cy.get('#react-tabs-0').click() // OPERATIONS
    cy.contains('.inner--emergencies > .fold > .container-lg > .fold__header > .fold__header__block > .fold__title', 'Highlighted Operations')
    cy.get('#react-tabs-2').click() // 3W
    cy.contains('.tc-top > .fold__title > span', 'Movement activities')
  })

  it('checks field report creation', () => {
    cy.visit('http://localhost:3000/reports/new/')
    loginHere()
    cy.wait(300)
    // cy.contains('.styles_heading__2SPPb', 'create field report')
    cy.get(':nth-child(4) > .styles_section-content__3E58e > :nth-child(1) > .go-input-internal-input-section > .styles_internal-input-container__1tC5- > .styles_select__1a7aA > .go__control > .go__value-container')
    .type('Spain{enter}')
    cy.get(':nth-child(2) > .go-input-internal-input-section > .styles_internal-input-container__1tC5- > .styles_select__1a7aA > .go__control > .go__value-container')
    .type('Aragon')
    cy.get(':nth-child(5) > .styles_section-content__3E58e > .go-input-container > .go-input-internal-input-section > .styles_internal-input-container__1tC5- > .styles_select__1a7aA > .go__control > .go__value-container')
    .type('Drought{enter}')
    cy.get('.styles_section-content__3E58e > .go-input-container > .go-input-internal-input-section > .styles_internal-input-container__1tC5- > .go-raw-input')
    .type('2022-01-01')
    cy.get('tr > :nth-child(2) > .go-input-container > .go-input-internal-input-section > .styles_internal-input-container__1tC5- > .go-raw-input')
    .type('Example Field Report{enter}')
    cy.get(':nth-child(8) > .styles_section-content__3E58e > .styles_radio-input__3ArJz > .styles_radio-list-container__WLomQ > :nth-child(2) > .styles_icons__3T5yJ > .styles_icon__HI6JB')
    .click()
    cy.get(':nth-child(9) > .styles_section-content__3E58e > .styles_radio-input__3ArJz > .styles_radio-list-container__WLomQ > :nth-child(2) > .styles_icons__3T5yJ > .styles_icon__HI6JB')
    .click()
    cy.get('.button--secondary-filled').click()
    cy.get('.button--secondary-filled').click()
    cy.get('.button--secondary-filled').click()
    // Why this does not work? Changes permission level? v
    // cy.get(':nth-child(5) > .styles_section-content__3E58e > .styles_radio-input__3ArJz > .styles_radio-list-container__WLomQ > :nth-child(3) > .styles_icons__3T5yJ > .styles_icon__HI6JB')    .click()
    cy.get('.styles_actions__1KZul > .button--primary-filled').click()
    cy.wait(1000)  // maybe can be omitted
    cy.contains('.inpage__title', 'ESP: Drought - 2022-01 - Example Field Report')
  })

//  it('logs in using cy.request', () => {
  it('logs in again', () => {
    login()
    cy.get('.nav-global-menu > :nth-child(2) > .drop__toggle--caret > span').click()
    cy.get(':nth-child(5) > .drop__menu-item').click()
    cy.contains('.inpage__title', 'Middle East & North Africa')
    cy.get('#react-tabs-0').click()  // OPERATIONS
    cy.contains('#appeals > .container-lg > .fold__header > .fold__header__block > .fold__title', 'Active IFRC Operations')
    cy.get('#react-tabs-6').click()  // REGIONAL PROFILE
    cy.contains('.regional-profile-subtitle', 'National Societies in Middle East & North Africa')
    //? cy.get('#react-tabs-8').click()  // PREPAREDNES
    //? cy.contains('.snippet_item > a','How we engage')
    //cy.expect(localStorage.getItem('user'))  // has...
  })

  it('logs in once more', () => {
    login()
    cy.get('.nav-global-menu > :nth-child(3) > a > span').click()
    cy.contains('.inpage__title > span', 'Emergencies in the last 30 days')
    //cy.get('.inner--emergencies-table-map > .fold > .container-lg > .fold__body > .table > tbody > :nth-child(1) > .table__cell--name > .link--table').click()
    //cy.contains('.container-mid > .box__global > .heading__title', 'Emergency Overview')
    //cy.get('#react-tabs-2').click()
    //cy.contains('.fold__title','Reports')
  })

  it('checks PER overview form creation', () => {
    loginUI()
    cy.get('.page__meta-nav > .drop__toggle').click()
    cy.get(':nth-child(1) > .drop__menu-item').click()
    cy.contains('.inpage__title', 'Hello ')
    cy.get('#react-tabs-4').click({force: true})  // PER Forms
    cy.contains('.fold__title', 'Completed PER Assessments')
    cy.get('.text-center > .button').click({force: true})
    cy.get('#react-tabs-10')  // overview
    cy.contains(':nth-child(2) > figcaption > .fold__title > span', 'Current PER Assessment')
    cy.get('#country_id > .css-yk16xz-control > .css-g1d714-ValueContainer')  // National Society
    .type('Austrian{enter}')
    cy.get('#date_of_assessment')
    .type('2022-07-01')
    cy.get('#type_of_assessment > .css-yk16xz-control > .css-g1d714-ValueContainer')  // Type of assassment
    .type('Ope{enter}')
    cy.get('#date_of_mid_term_review')
    .type('2022-08-01')
    cy.get('#date_of_next_asmt')
    .type('2022-09-01')
    cy.get('#facilitator_name')
    .type('Browser Cru{enter}')
    cy.get('#facilitator_email')
    .type('browser@cru.qw{enter}')
    cy.get('#facilitator_phone')
    .type('11 11119{enter}')
    cy.get('.text-center > .button').click()  // follow the forms
    cy.contains('.h3 > span', 'Overview')
    cy.scrollTo(100, 100) 
    cy.wait(4000)  // without this the save button can not be seen. Or shall we trace modal popup?
    cy.get('.react-tabs > .text-right > .button > span').click({force: true})  // save
    cy.get('.per-inpage__header > .text-right > .button--primary-filled > span').click({force: true})  // final submit
    cy.get('.tc-footer > .button--primary-filled').click({force: true})  // confirm
  })

  //it('checks resources', () => {
  //  cy.visit('http://localhost:3000/about/')
  //})
})

