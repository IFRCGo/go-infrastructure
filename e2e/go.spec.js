/// <reference types="cypress" />
// https://docs.cypress.io/examples/examples/tutorials#Best-Practices
// https://docs.cypress.io/api/cypress-api/cookies#Preserve-Once ! Log in only once – tbd.
// https://glebbahmutov.com/blog/keep-passwords-secret-in-e2e-tests/
// https://example.cypress.io/commands/waiting
// https://github.com/cypress-io/cypress-realworld-app | https://www.cypress.io/blog/2020/06/11/introducing-the-cypress-real-world-app/
// https://www.cypress.io/blog/2019/05/02/run-cypress-with-a-single-docker-command/

import { login } from '../../support'

context('Actions', () => {
  beforeEach(() => {
    Cypress.Cookies.preserveOnce('sessionid, csrftoken, UILanguage')
  })

  it('checks a 3W endpoint', () => {
    cy.visit('http://localhost:3000/three-w')
    cy.contains('.styles_heading__2SPPb', 'Global 3W Response')
    cy.contains(':nth-child(2) > .styles_title__1rd77', 'Programme Type')
    cy.get(':nth-child(3) > [href="/about"] > span').click()
    cy.contains('.about__resources__block > .container-lg > div.text-center > .line-brand-deco-border-top-wrap > .fold__title > span', 'IFRC Resources')
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
    })

    
  })

  it('logs in via UI', () => {
    cy.visit('http://localhost:3000/')
    const username = Cypress.env('some')
    const password = Cypress.env('secret')

    expect(username, 'username was set').to.be.a('string').and.not.be.empty
//    expect(password, 'password was set').to.be.a('string').and.not.be.empty
    if (typeof password !== 'string' || !password) {
      throw new Error('Missing password value, set using CYPRESS_variablename=...')
    }

    cy.get('.page__meta-nav > [title="Login"] > span').click(); // https://docs.cypress.io/api/commands/click#Usage
    cy.get('#login-username').type(username)
    cy.get('#login-password').type(password)
    cy.get('.form__footer > .button > span').click()

    cy.contains('.page__meta-nav > .drop__toggle > span', 'test user')
    cy.get('.nav-global-menu > :nth-child(2) > .drop__toggle--caret > span').click()
    cy.get(':nth-child(4) > .drop__menu-item').click()
    cy.contains('.inpage__title', 'Europe')
    cy.get('#react-tabs-0').click() // OPERATIONS
    cy.contains('.inner--emergencies > .fold > .container-lg > .fold__header > .fold__header__block > .fold__title', 'Highlighted Operations')
    cy.get('#react-tabs-2').click() // 3W
    cy.contains('.tc-top > .fold__title > span', 'Movement activities')
    cy.wait(1000)

//    cy.getCookie('sessionid').should('exist')
//    cy.contains('a', 'profile').should('be.visible').click()
//    cy.url().should('match', /profile$/)
//    cy.contains('Email: jack@example.com')
  })

//  it('logs in using cy.request', () => {
  it('logs in again', () => {
    login()
    cy.wait(1000)
    cy.get('.nav-global-menu > :nth-child(2) > .drop__toggle--caret > span').click()
    cy.get(':nth-child(5) > .drop__menu-item').click()
    cy.contains('.inpage__title', 'Middle East & North Africa')
    cy.get('#react-tabs-0').click()  // OPERATIONS
    cy.contains('#appeals > .container-lg > .fold__header > .fold__header__block > .fold__title', 'Active IFRC Operations')
    cy.get('#react-tabs-4').click()  // REGIONAL PROFILE
    cy.contains('.regional-profile-subtitle', 'National Societies in Middle East & North Africa')
    cy.get('#react-tabs-6').click()  // PREPAREDNES
    cy.contains('.snippet_item > a','How we engage')
    //cy.expect(localStorage.getItem('user'))  // has...
  })

  it('logs in once more', () => {
    login()
    cy.wait(1000)
    cy.get('.nav-global-menu > :nth-child(3) > a > span').click()
    cy.contains('.inpage__title > span', 'Emergencies in the last 30 days')
    cy.get('.inner--emergencies-table-map > .fold > .container-lg > .fold__body > .table > tbody > :nth-child(1) > .table__cell--name > .link--table').click()
    cy.contains('.container-mid > .box__global > .heading__title', 'Emergency Overview')
    cy.get('#react-tabs-2').click()
    cy.contains('.fold__title','Reports')

  })

  //it('checks resources', () => {
  //  cy.visit('http://localhost:3000/about/')
  //})  

})
