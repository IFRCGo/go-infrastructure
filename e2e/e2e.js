// ***********************************************************
// This example support/index.js is processed and
// loaded automatically before your test files.
//
// This is a great place to put global configuration and
// behavior that modifies Cypress.
//
// You can change the location of this file or turn off
// automatically serving support files with the
// 'supportFile' configuration option.
//
// You can read more here:
// https://on.cypress.io/configuration
// ***********************************************************

// Import commands.js using ES2015 syntax:
// import './commands'

// Alternatively you can use CommonJS syntax:
// require('./commands')

/**
 * Logs the user by making API call to POST /login.
 * Make sure "cypress.json" + CYPRESS_ environment variables
 * have username and password values set.
 */
export const login = () => {
  const username = Cypress.env('some')
  const password = Cypress.env('secret')

  // it is ok for the username to be visible in the Command Log
  expect(username, 'username was set').to.be.a('string').and.not.be.empty
  // but the password value should not be shown
  if (typeof password !== 'string' || !password) {
    throw new Error('Missing password value, set using CYPRESS_secret=...')
  }

  cy.request({
    method: 'POST',
    url: 'https://dsgocdnapi.azureedge.net/get_auth_token',
    form: true,
    body: {
      username,
      password
    }
  }).as('getauthtoken')
  cy.get('@getauthtoken').should((response) => {
    console.log(response.body.token) // todo: how to save in variable and use later?
    // cy.getCookie('sessionid').should('exist')
  })
  cy.visit('http://localhost:3000/')
}

export const loginUI = () => {
  const username = Cypress.env('some')
  const password = Cypress.env('secret')

  // it is ok for the username to be visible in the Command Log
  expect(username, 'username was set').to.be.a('string').and.not.be.empty
  // but the password value should not be shown
  if (typeof password !== 'string' || !password) {
    throw new Error('Missing password value, set using CYPRESS_secret=...')
  }

  cy.visit('http://localhost:3000/login')
  cy.get('#login-username').type(username)
  cy.get('#login-password').type(password)
  cy.get('.form__footer > .button > span').click()
}

export const loginHere = () => {
  const username = Cypress.env('some')
  const password = Cypress.env('secret')

  // it is ok for the username to be visible in the Command Log
  expect(username, 'username was set').to.be.a('string').and.not.be.empty
  // but the password value should not be shown
  if (typeof password !== 'string' || !password) {
    throw new Error('Missing password value, set using CYPRESS_secret=...')
  }
  cy.get('#login-username').type(username)
  cy.get('#login-password').type(password)
  cy.get('.form__footer > .button > span').click()
}

export const urlExists = (url, callback) => { // stackoverflow.com/questions/1591401/javascript-jquery-check-broken-links
  var xhr = new XMLHttpRequest();
  xhr.onreadystatechange = function() {
    if (xhr.readyState === 4) {
      callback(xhr.status < 400);
    }
  };
  xhr.open('HEAD', url);
  xhr.send();
}
