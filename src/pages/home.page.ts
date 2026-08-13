import { Page, Locator } from '@playwright/test';
import { link } from 'fs';

/**
 * Page Object para la página de inicio
 * Encapsula selectores y acciones de la UI
 */
export class HomePage {
  private readonly page: Page;
  
  // Selectores
  private readonly signInMenu: Locator;
  private readonly signInButton: Locator;
  private readonly acceptCookies: Locator
  private readonly closePopUp: Locator
  private readonly idEmail: Locator;
  private readonly idPassword: Locator;
  private readonly loginButton: Locator;

  constructor(page: Page) {
    this.page = page;
    this.signInMenu = page.locator('//button[@class="my-account-button_myAccountButton__Pdkav"]');
    this.signInButton = this.page.getByRole('link', {name: 'Sign In', exact:true});
    this.acceptCookies = page.locator('button[id="onetrust-accept-btn-handler"]');
    this.closePopUp = page.locator('div[class^="pop-up_closeIcon"]');
    this.idEmail = page.locator('input[id="email"]');
    this.idPassword = page.locator('input[id="password"]');
    this.loginButton = page.locator('button[id="loginFormSubmitBtn"]');
  }

  /**
   * Navega a la página de inicio
   */
  async navigate(): Promise<void> {
    // Para demostración, navegamos a una página de ejemplo
    // En un caso real, esto sería la URL de tu aplicación
    await this.page.goto('https://fifa.com/en');
    //await this.page.waitForLoadState('networkidle');
   
  }

  async closeWindows(): Promise<void>{
    //await this.acceptCookies.isVisible({timeout: 5000});
    await this.page.keyboard.press('Escape');
    await this.page.keyboard.press('Escape');
    await this.page.keyboard.press('Escape');
    await this.closePopUp.click();
    //await this.closePopUp.click();//borrar este cambio
  }

  /**
   * Hace clic en el botón de login
   */
  async clickSignInMenu(): Promise<void> {
    //await this.signInMenu.waitFor({ state: 'visible' });
    await this.signInMenu.click();
     //await this.signInButton.waitFor({ state: 'visible' });
  }
  
   async clickSignInButton(): Promise<Page> {

    const [popup] = await Promise.all([
      this.page.waitForEvent('popup'),
      this.signInButton.click(),
    ]);
    await popup.bringToFront();
    return popup;
  }

    async enterCredentials(username: string, password: string){
      await this.idEmail.waitFor({state: 'visible', timeout: 10000});
      await this.idEmail.fill(username);
      await this.idPassword.fill(password);
  }
  
    async pressSubmitButton(): Promise<void>{
      await this.loginButton.click();
  }
/*
  
   //Verifica si el usuario está autenticado
   
  async isUserAuthenticated(): Promise<boolean> {
    try {
      await this.userMenu.waitFor({ state: 'visible', timeout: 5000 });
      return true;
    } catch {
      return false;
    }
  }



 
   //Obtiene el título de la página
 
  async getTitle(): Promise<string> {
    return await this.page.title();
  }


   //Espera a que la página esté completamente cargada

  async waitForPageLoad(): Promise<void> {
    await this.page.waitForLoadState('networkidle');
    await this.page.waitForTimeout(1000); // Pequeña espera adicional
  }

*/
}
