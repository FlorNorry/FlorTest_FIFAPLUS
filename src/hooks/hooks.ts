import { Before, BeforeAll, After, AfterAll, Status } from '@cucumber/cucumber';
import { chromium, Browser, BrowserContext, Page } from '@playwright/test';
import { CustomWorld } from '../support/custom-world';

let browser: Browser;
let context: BrowserContext;

/**
 * BeforeAll: Se ejecuta una vez antes de todos los escenarios
 * Inicializa el navegador
 */
BeforeAll(async function () {
  console.log('🚀 Iniciando navegador Chromium...');
  browser = await chromium.launch({
    headless: process.env.HEADLESS =='false',
    slowMo: parseInt(process.env.SLOW_MO || '100'),
    args: ['--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
      '--disable-web-security',
      '--disable-features=VizDisplayCompositor'
    ]
  });
  console.log('✅ Navegador iniciado exitosamente');
});

/**
 * Before: Se ejecuta antes de cada escenario
 * Crea un nuevo contexto y página para el escenario
 */
Before(async function (this: CustomWorld) {
  console.log('🔧 Creando contexto y página para el escenario...');

  
  context = await browser.newContext({
    baseURL: process.env.BASE_URL || 'https://www.fifa.com/en',
    viewport: null,
    //{ width: 1920, height: 1080 },
    ignoreHTTPSErrors: true,
    recordVideo: {
      dir: 'reports/videos/',
      size: { width: 1920, height: 1080 }
    }
  });

  this.context = context;
  this.page = await context.newPage();
  
  await this.context.addCookies([
    {
      name:'OptanonAlertBoxClosed',
      value: new Date().toISOString(),
      domain: '.fifa.com',
      path: '/'
    }
    ]);

  // Configurar timeouts
  this.page.setDefaultTimeout(30 * 1000);
  this.page.setDefaultNavigationTimeout(60000);
  
  console.log('✅ Contexto y página creados exitosamente');
});

/**
 * After: Se ejecuta después de cada escenario
 * Toma captura de pantalla si el escenario falla y limpia recursos
 */
After(async function (this: CustomWorld, scenario) {
  console.log(`🧹 Limpiando recursos del escenario: ${scenario.pickle.name}`);
  
  // Si el escenario falló, tomar captura de pantalla
  if (scenario.result?.status === Status.FAILED) {
    console.log('❌ Escenario falló. Tomando captura de pantalla...');
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const screenshotName = `failed-${scenario.pickle.name.replace(/[^a-zA-Z0-9]/g, '-')}-${timestamp}`;
    const screenshotPath = `screenshots/${screenshotName}.png`;
    
    await this.page.screenshot({ 
      path: screenshotPath, 
      fullPage: true 
    });
    console.log(`📸 Captura de pantalla guardada en: ${screenshotPath}`);
    
    // Adjuntar la captura al reporte
    this.attach(await this.page.screenshot({ fullPage: true }), 'image/png');
  }

  // Cerrar página y contexto
  if (this.page) {
    await this.page.close();
  }
  if (context) {
    await context.close();
  }
  
  console.log('✅ Recursos del escenario limpiados');
});

/**
 * AfterAll: Se ejecuta una vez después de todos los escenarios
 * Cierra el navegador
 */
AfterAll(async function () {
  console.log('🔚 Cerrando navegador...');
  if (browser) {
    await browser.close();
  }
  console.log('✅ Navegador cerrado exitosamente');
});