import { Page, Locator, expect } from '@playwright/test';
import { url } from 'inspector';
import { title } from 'process';

export class NavigationPage{
    private readonly page: Page;

    //private readonly urlButton: Locator;
   // private readonly titleInNews: Locator;
    private readonly footerCopyright: Locator;
  //  private readonly xpath: String;
  
    
    constructor(page: Page){
        this.page = page;
        //this.newsButton = page.locator('(//div[a[text()="NEWS"]])[2]');
        //this.titleInNews = page.locator('(//span[text()="Latest news"])[2]');
        
       // this.xpath = '(//span[text()="Latest news"])[2]';
        // Texto de copyright del footer (robusto: ignora espaciado exacto del guion)
        this.footerCopyright = page.getByText(/Copyright.*FIFA.*All rights reserved/i);
    }


      private geUrlLocator(url: string): Locator{
        // Toma el link visible con ese texto (sirve para NEWS y RANKINGS,
        // sin depender de cuántas veces aparezca en el header)
        return this.page.locator(`//a[normalize-space(text())="${url}"]`).locator('visible=true').first();
    }

    private getTitleLocator(title: string): Locator{
        // Usa el heading (h1/h2/h3) visible que contiene el título.
        // Robusto para "Latest news" (texto duplicado) y "FIFA Rankings".
        return this.page.getByRole('heading', { name: title }).first();
    }

    async clickOnOptionAndValidate(url: string, title: string): Promise<void> {
        //await this.newsButton.click();
        const optionUrl = this.geUrlLocator(url);
        await optionUrl.click();
        const titleLocator = this.getTitleLocator(title);
        await expect(titleLocator).toBeVisible();
      

      
    }

    async scrollToFooter(): Promise<void> {
        // Baja al fondo de la página para forzar la carga del footer (lazy-load)
        await this.page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
        // Asegura que el copyright quede a la vista y valida que sea visible
        await this.footerCopyright.scrollIntoViewIfNeeded();
        await expect(this.footerCopyright).toBeVisible();
    }

    async validaTitulo(): Promise<void> {
        
        
    }


}