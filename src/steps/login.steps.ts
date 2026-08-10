  import { Given, When, Then } from '@cucumber/cucumber';
  import { expect } from '@playwright/test';
  import { CustomWorld } from '../support/custom-world';
  import { HomePage } from '../pages/home.page';
import { parseArgs } from 'util';

// And es un alias que puede ser When, Then, o Given dependiendo del contexto
// Lo definimos manualmente como alias de estos

/**
 * Step Definitions for the login flow
 * Implements Gherkin scenarios in English
 */

// Steps para el Scenario Outline principal del feature file
Given('a user in the FIFA page', {timeout: 60000}, async function (this: CustomWorld) {
  const homePage = new HomePage(this.page);
  await homePage.navigate();
  await homePage.closeWindows();
 // await homePage.waitForPageLoad();
});

When('the user click on sign in button', {timeout: 60000}, async function(this: CustomWorld) {
  const homePage = new HomePage(this.page);
  await homePage.clickSignInMenu();
  this.page = await homePage.clickSignInButton();
});


When('enter valid credentials {string} and {string}', {timeout: 60000}, async function(this: CustomWorld, username: string, password: string) {
  const homePage = new HomePage(this.page);
  await homePage.enterCredentials(username, password);
});

When('click on submit button', {timeout: 60000}, async function(this: CustomWorld) {
  const homePage = new HomePage(this.page);
  await homePage.pressSubmitButton();
  await this.page.waitForTimeout(1000); // Wait for login to process
});

Then('the user is loggued in the fifa page correctly', {timeout: 60000}, async function(this: CustomWorld) {
  // Verify user is logged in by checking for authenticated elements
  await expect(this.page.locator('.user-profile, .dashboard, .main-content')).toBeVisible();
  // Alternatively, verify URL contains dashboard or authenticated page
  expect(this.page.url()).toMatch(/dashboard|fifa|authenticated/);
});





