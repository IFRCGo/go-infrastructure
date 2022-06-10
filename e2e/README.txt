The Cypress test tools are here.
The Cypress engine can be obtained from here freely: https://docs.cypress.io/guides/getting-started/installing-cypress
The direct download (https://download.cypress.io/desktop) is the simplest way recently – it is an all-in-one application.

The GO-related files and the Cypress core infrastructure are in two distinct directories.
So it is possible to upgrade Cypress core without touching the GO-related files.
Recently we use cypress 10.0.3.

First start: unzip cypress.zip, then run: Cypress/Cypress
If there is an old config somewhere (e.g. .config/Cypress), it should be removed befpre-
The e2e.js file should be in "cypress/support" directory,
go.cy.js in "cypress/integration/3-own",
and cypress.json in the root ("cypress").

A demo run and some practical advice can be seen here: https://ifrcorg.sharepoint.com/sites/GOIVfordeveloperteam/Shared%20Documents/General/GO%20developer%20onboarding/Cypress%20test%20automation/cypress1.mp4
or the same: https://porgeto.hu/cypress1.mp4
