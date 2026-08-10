import { IWorldOptions, setWorldConstructor, World } from '@cucumber/cucumber';
import { Browser, BrowserContext, Page } from '@playwright/test';

/**
 * Custom World para Cucumber con Playwright
 * Proporciona acceso tipado a las instancias de Playwright
 */
export class CustomWorld extends World {
  public browser!: Browser;
  public context!: BrowserContext;
  public page!: Page;

  constructor(options: IWorldOptions) {
    super(options);
  }

  /**
   * Obtiene la página actual del contexto
   */
  public getPage(): Page {
    if (!this.page) {
      throw new Error('Page no está inicializada. Asegúrate de que los hooks se ejecuten correctamente.');
    }
    return this.page;
  }

  /**
   * Espera un tiempo determinado
   */
  public async wait(milliseconds: number): Promise<void> {
    await this.page.waitForTimeout(milliseconds);
  }

  /**
   * Toma una captura de pantalla
   */
  public async takeScreenshot(fileName?: string): Promise<string> {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const screenshotName = fileName || `screenshot-${timestamp}`;
    const screenshotPath = `screenshots/${screenshotName}.png`;
    
    await this.page.screenshot({ 
      path: screenshotPath, 
      fullPage: true 
    });
    
    return screenshotPath;
  }
}

// Registrar el World personalizado
setWorldConstructor(CustomWorld);
