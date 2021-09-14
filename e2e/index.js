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
import './commands'

// Alternatively you can use CommonJS syntax:
// require('./commands')

/**
 * Logs the user by making API call to POST /login.
 * Make sure "cypress.json" + CYPRESS_ environment variables
 * have username and password values set.
 */
export const login1 = () => {
  const username = Cypress.env('some')
  const password = Cypress.env('secret')

  // it is ok for the username to be visible in the Command Log
  expect(username, 'username was set').to.be.a('string').and.not.be.empty
  // but the password value should not be shown
  if (typeof password !== 'string' || !password) {
    throw new Error('Missing password value, set using CYPRESS_password=...')
  }

  cy.request({
    method: 'POST',
    url: 'https://dsgocdnapi.azureedge.net/get_auth_token',
    form: true,
    body: {
      username,
      password
    }
  })
}
export const login = () => {
  const username = Cypress.env('some')
  const password = Cypress.env('secret')

  // it is ok for the username to be visible in the Command Log
  expect(username, 'username was set').to.be.a('string').and.not.be.empty
  // but the password value should not be shown
  if (typeof password !== 'string' || !password) {
    throw new Error('Missing password value, set using CYPRESS_password=...')
  }

  cy.visit('http://localhost:3000/login')
  cy.get('#login-username').type(username)
  cy.get('#login-password').type(password)
  cy.get('.form__footer > .button > span').click()
}