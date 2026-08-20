import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { CustomWorld } from '../support/custom-world';
import { NavigationPage } from '../pages/navigation.page';

When ('click on option {string} and validate the {string}', {timeout: 60000}, async function(this: CustomWorld, url: string, title: string) {
    const navigationPage = new NavigationPage(this.page);
    await navigationPage.clickOnOptionAndValidate(url,title);
})


Then ('the user scrolls to the bottom of the page', {timeout: 60000}, async function(this: CustomWorld){
    const navigationPage = new NavigationPage(this.page);
    await navigationPage.scrollToFooter();


})


Then ('the footer should be visible', {timeout: 60000}, async function(this: CustomWorld){

})