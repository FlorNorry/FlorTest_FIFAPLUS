#!/bin/bash

# =============================================================================
# 🚀 SCRIPT DE CONFIGURACIÓN AUTOMÁTICA - PROYECTO PLAYWRIGHT + TYPESCRIPT + CUCUMBER
# QA Automation Engineer Senior Expert
# =============================================================================

echo "🎯 Iniciando configuración del proyecto de automatización..."

# Crear estructura de carpetas
echo "📁 Creando estructura de carpetas..."
mkdir -p src/{pages,steps,support}
mkdir -p features
mkdir -p reports
mkdir -p screenshots

# Inicializar proyecto Node.js
echo "📦 Inicializando proyecto Node.js..."
npm init -y

# Instalar dependencias principales
echo "⬇️ Instalando dependencias principales..."
npm install @playwright/test @cucumber/cucumber ts-node typescript

# Instalar dependencias de desarrollo
echo "🔧 Instalando dependencias de desarrollo..."
npm install -D @types/node @types/cucumber

# Instalar navegadores de Playwright
echo "🌐 Instalando navegadores de Playwright..."
npx playwright install chromium

# Generar package.json con scripts configurados
echo "📄 Generando package.json..."
cat > package.json << 'EOF'
{
  "name": "playwright-cucumber-bdd-project",
  "version": "1.0.0",
  "description": "Proyecto de automatización web con Playwright, TypeScript y Cucumber BDD",
  "main": "index.js",
  "scripts": {
    "test": "cucumber-js --require-module ts-node/register --require src/hooks/hooks.ts --require src/steps/*.ts --format json:reports/cucumber-report.json --format html:reports/cucumber-report.html --format pretty",
    "test:parallel": "cucumber-js --require-module ts-node/register --require src/hooks/hooks.ts --require src/steps/*.ts --format json:reports/cucumber-report.json --format html:reports/cucumber-report.html --format pretty --parallel 4",
    "test:debug": "cucumber-js --require-module ts-node/register --require src/hooks/hooks.ts --require src/steps/*.ts --format pretty --tags @debug",
    "playwright:install": "npx playwright install",
    "clean:reports": "rm -rf reports/* screenshots/*"
  },
  "keywords": [
    "playwright",
    "cucumber",
    "bdd",
    "typescript",
    "automation",
    "testing"
  ],
  "author": "QA Automation Engineer",
  "license": "MIT",
  "dependencies": {
    "@cucumber/cucumber": "^10.3.1",
    "@playwright/test": "^1.40.1",
    "ts-node": "^10.9.1",
    "typescript": "^5.3.3"
  },
  "devDependencies": {
    "@types/cucumber": "^7.0.0",
    "@types/node": "^20.10.4"
  }
}
EOF

# Generar tsconfig.json
echo "⚙️ Generando tsconfig.json..."
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020", "DOM"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    "moduleResolution": "node",
    "allowSyntheticDefaultImports": true,
    "noImplicitAny": true,
    "noImplicitReturns": true,
    "noImplicitThis": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "exactOptionalPropertyTypes": true,
    "noImplicitOverride": true,
    "noPropertyAccessFromIndexSignature": true,
    "noUncheckedIndexedAccess": true
  },
  "include": [
    "src/**/*",
    "features/**/*"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "reports"
  ],
  "ts-node": {
    "require": ["tsconfig-paths/register"]
  }
}
EOF

# Generar cucumber.js
echo "🥒 Generando cucumber.js..."
cat > cucumber.js << 'EOF'
module.exports = {
  default: {
    requireModule: ['ts-node/register'],
    require: ['src/hooks/hooks.ts', 'src/steps/*.ts'],
    format: [
      'json:reports/cucumber-report.json',
      'html:reports/cucumber-report.html',
      'pretty'
    ],
    formatOptions: {
      snippetInterface: 'async-await'
    },
    dryRun: false,
    failFast: false,
    snippets: true,
    snippetSyntax: undefined,
    strict: true,
    timeout: 60000,
    worldParameters: {},
    parallel: 4
  }
};
EOF

# Generar .gitignore
echo "🚫 Generando .gitignore..."
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build outputs
dist/
build/

# Reports and screenshots
reports/
screenshots/
test-results/
playwright-report/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
logs/
*.log

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Temporary files
tmp/
temp/
EOF

# Generar Custom World
echo "🌍 Generando Custom World..."
cat > src/support/custom-world.ts << 'EOF'
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
EOF

# Generar Hooks
echo "🪝 Generando Hooks..."
cat > src/hooks/hooks.ts << 'EOF'
import { Before, BeforeAll, After, AfterAll, Status } from '@cucumber/cucumber';
import { chromium, Browser, BrowserContext, Page } from '@playwright/test';
import { CustomWorld } from './custom-world';

let browser: Browser;
let context: BrowserContext;

/**
 * BeforeAll: Se ejecuta una vez antes de todos los escenarios
 * Inicializa el navegador
 */
BeforeAll(async function () {
  console.log('🚀 Iniciando navegador Chromium...');
  browser = await chromium.launch({
    headless: process.env.HEADLESS !== 'false',
    slowMo: parseInt(process.env.SLOW_MO || '0'),
    args: [
      '--no-sandbox',
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
    viewport: { width: 1920, height: 1080 },
    ignoreHTTPSErrors: true,
    recordVideo: {
      dir: 'reports/videos/',
      size: { width: 1920, height: 1080 }
    }
  });

  this.context = context;
  this.page = await context.newPage();
  
  // Configurar timeouts
  this.page.setDefaultTimeout(30000);
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
    const screenshotPath = await this.takeScreenshot(`failed-${scenario.pickle.name.replace(/[^a-zA-Z0-9]/g, '-')}`);
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
EOF

# Generar Page Object de ejemplo
echo "📄 Generando Page Object de ejemplo..."
cat > src/pages/home.page.ts << 'EOF'
import { Page, Locator } from '@playwright/test';

/**
 * Page Object para la página de inicio
 * Encapsula selectores y acciones de la UI
 */
export class HomePage {
  private readonly page: Page;
  
  // Selectores
  private readonly loginButton: Locator;
  private readonly searchInput: Locator;
  private readonly searchButton: Locator;
  private readonly userMenu: Locator;
  private readonly logoutButton: Locator;

  constructor(page: Page) {
    this.page = page;
    this.loginButton = page.locator('button[data-testid="login-button"]');
    this.searchInput = page.locator('input[placeholder*="Buscar"]');
    this.searchButton = page.locator('button[aria-label*="Buscar"]');
    this.userMenu = page.locator('div[data-testid="user-menu"]');
    this.logoutButton = page.locator('button[data-testid="logout-button"]');
  }

  /**
   * Navega a la página de inicio
   */
  async navigate(): Promise<void> {
    await this.page.goto('/');
    await this.page.waitForLoadState('networkidle');
  }

  /**
   * Hace clic en el botón de login
   */
  async clickLogin(): Promise<void> {
    await this.loginButton.waitFor({ state: 'visible' });
    await this.loginButton.click();
  }

  /**
   * Realiza una búsqueda
   */
  async search(query: string): Promise<void> {
    await this.searchInput.waitFor({ state: 'visible' });
    await this.searchInput.fill(query);
    await this.searchButton.click();
  }

  /**
   * Verifica si el usuario está autenticado
   */
  async isUserAuthenticated(): Promise<boolean> {
    try {
      await this.userMenu.waitFor({ state: 'visible', timeout: 5000 });
      return true;
    } catch {
      return false;
    }
  }

  /**
   * Cierra sesión
   */
  async logout(): Promise<void> {
    await this.userMenu.click();
    await this.logoutButton.waitFor({ state: 'visible' });
    await this.logoutButton.click();
  }

  /**
   * Obtiene el título de la página
   */
  async getTitle(): Promise<string> {
    return await this.page.title();
  }

  /**
   * Espera a que la página esté completamente cargada
   */
  async waitForPageLoad(): Promise<void> {
    await this.page.waitForLoadState('networkidle');
    await this.page.waitForTimeout(1000); // Pequeña espera adicional
  }
}
EOF

# Generar Step Definitions de ejemplo
echo "👣 Generando Step Definitions de ejemplo..."
cat > src/steps/login.steps.ts << 'EOF'
import { Given, When, Then, And } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { CustomWorld } from '../support/custom-world';
import { HomePage } from '../pages/home.page';

/**
 * Step Definitions para el flujo de login
 * Implementa los escenarios Gherkin en español
 */

Given('que estoy en la página de inicio', async function (this: CustomWorld) {
  const homePage = new HomePage(this.page);
  await homePage.navigate();
  await homePage.waitForPageLoad();
});

When('hago clic en el botón de login', async function (this: CustomWorld) {
  const homePage = new HomePage(this.page);
  await homePage.clickLogin();
});

When('ingreso mis credenciales válidas {string} y {string}', async function (this: CustomWorld, username: string, password: string) {
  // Aquí iría la lógica para ingresar credenciales en el formulario de login
  // Por ahora, simulamos el ingreso
  await this.page.fill('input[name="username"]', username);
  await this.page.fill('input[name="password"]', password);
  await this.page.click('button[type="submit"]');
});

When('hago clic en el botón de submit', async function (this: CustomWorld) {
  // Este paso está incluido en el paso anterior, pero lo mantenemos por separación de responsabilidades
  await this.page.waitForTimeout(1000); // Esperar a que se procese el login
});

Then('debería ser redirigido al dashboard', async function (this: CustomWorld) {
  await this.page.waitForURL('**/dashboard');
  expect(this.page.url()).toContain('/dashboard');
});

Then('debería ver mi nombre de usuario {string} en la interfaz', async function (this: CustomWorld, username: string) {
  const userElement = this.page.locator(`text=${username}`);
  await expect(userElement).toBeVisible();
});

And('debería permanecer en la página de login', async function (this: CustomWorld) {
  await this.page.waitForTimeout(1000);
  expect(this.page.url()).toContain('/login');
});

And('debería ver un mensaje de error {string}', async function (this: CustomWorld, errorMessage: string) {
  const errorElement = this.page.locator('.error-message');
  await expect(errorElement).toBeVisible();
  await expect(errorElement).toContainText(errorMessage);
});

Given('que estoy autenticado como {string}', async function (this: CustomWorld, username: string) {
  const homePage = new HomePage(this.page);
  await homePage.navigate();
  
  // Simular autenticación directa (en un caso real, haríamos login completo)
  await this.page.evaluate((user) => {
    localStorage.setItem('user', JSON.stringify({ username: user, authenticated: true }));
  }, username);
  
  await this.page.reload();
  await homePage.waitForPageLoad();
});

When('busco el término {string}', async function (this: CustomWorld, searchTerm: string) {
  const homePage = new HomePage(this.page);
  await homePage.search(searchTerm);
});

Then('debería ver resultados relacionados con {string}', async function (this: CustomWorld, searchTerm: string) {
  await this.page.waitForSelector('.search-results');
  const results = this.page.locator('.search-result-item');
  const count = await results.count();
  expect(count).toBeGreaterThan(0);
  
  // Verificar que al menos un resultado contiene el término buscado
  const firstResult = results.first();
  await expect(firstResult).toContainText(searchTerm, { ignoreCase: true });
});
EOF

# Generar Feature file de ejemplo en español
echo "📋 Generando Feature file de ejemplo..."
cat > features/login.feature << 'EOF'
# language: es
@functional @login
Feature: Autenticación de Usuarios

  Como usuario de la aplicación
  Quiero poder autenticarme de forma segura
  Para acceder a las funcionalidades protegidas

  Background:
    Given que estoy en la página de inicio

  @smoke @positive
  Scenario: Login exitoso con credenciales válidas
    When hago clic en el botón de login
    And ingreso mis credenciales válidas "usuario.valido" y "contraseña.segura123"
    And hago clic en el botón de submit
    Then debería ser redirigido al dashboard
    And debería ver mi nombre de usuario "usuario.valido" en la interfaz

  @negative @security
  Scenario Outline: Login fallido con credenciales inválidas
    When hago clic en el botón de login
    And ingreso mis credenciales válidas "<username>" y "<password>"
    And hago clic en el botón de submit
    Then debería permanecer en la página de login
    And debería ver un mensaje de error "<mensaje_error>"

    Examples:
      | username           | password           | mensaje_error                     |
      | usuario.inexistente | contraseña.falsa   | Usuario o contraseña incorrectos  |
      | ""                 | contraseña.falsa   | El usuario es requerido           |
      | usuario.valido     | ""                 | La contraseña es requerida        |
      | usuario.valido     | contraseña.incorrecta | Usuario o contraseña incorrectos  |

  @search @authenticated
  Scenario: Búsqueda de productos cuando está autenticado
    Given que estoy autenticado como "usuario.busqueda"
    When busco el término "Playwright"
    Then debería ver resultados relacionados con "Playwright"

  @debug @wip
  Scenario: Prueba de depuración
    Given que estoy en la página de inicio
    When espero 3 segundos
    Then debería ver el título de la página
EOF

# Crear archivo README.md con instrucciones
echo "📖 Generando README.md con instrucciones..."
cat > README.md << 'EOF'
# 🚀 Proyecto de Automatización Web con Playwright + TypeScript + Cucumber BDD

Proyecto de automatización de pruebas web construido con las mejores prácticas de la industria, utilizando TypeScript, Playwright y Cucumber (BDD).

## 🛠️ Stack Tecnológico

- **Lenguaje**: TypeScript
- **Framework de Automatización**: Playwright (@playwright/test)
- **Framework BDD**: Cucumber.js (@cucumber/cucumber)
- **Ejecución TypeScript**: ts-node
- **Tipo de Pruebas**: Web (UI)

## 📁 Estructura del Proyecto

```
├── src/
│   ├── pages/              # Page Objects (POM)
│   │   └── home.page.ts
│   ├── steps/              # Step Definitions
│   │   └── login.steps.ts
│   └── support/            # Configuración y utilidades
│       ├── custom-world.ts # World personalizado de Cucumber
│       └── hooks.ts        # Hooks de ciclo de vida
├── features/               # Archivos Gherkin (.feature)
│   └── login.feature
├── reports/                # Reportes de ejecución
├── screenshots/            # Capturas de pantalla
├── package.json
├── tsconfig.json
├── cucumber.js
└── .gitignore
```

## 🚀 Instalación y Configuración

### 1. Ejecutar el script de configuración

```bash
chmod +x setup.sh
./setup.sh
```

### 2. Instalar navegadores de Playwright

```bash
npm run playwright:install
```

## 🏃‍♂️ Ejecución de Pruebas

### Ejecutar todas las pruebas
```bash
npm test
```

### Ejecutar pruebas en paralelo (4 hilos)
```bash
npm run test:parallel
```

### Ejecutar pruebas con tag específico
```bash
npm test -- --tags "@smoke"
```

### Ejecutar un escenario específico
```bash
npm test -- --name "Login exitoso"
```

### Ejecutar en modo debug
```bash
npm run test:debug
```

## 🏷️ Tags Disponibles

- `@smoke`: Pruebas críticas de humo
- `@functional`: Pruebas funcionales
- `@positive`: Casos de prueba positivos
- `@negative`: Casos de prueba negativos
- `@security`: Pruebas de seguridad
- `@search`: Pruebas de búsqueda
- `@authenticated`: Pruebas que requieren autenticación
- `@debug`: Pruebas para depuración
- `@wip`: Trabajo en progreso

## 📊 Reportes

Los reportes se generan automáticamente en la carpeta `reports/`:

- `cucumber-report.json`: Reporte en formato JSON
- `cucumber-report.html`: Reporte HTML interactivo
- `videos/`: Grabaciones de video de los escenarios

## 📸 Capturas de Pantalla

Las capturas de pantalla se toman automáticamente cuando un escenario falla y se guardan en la carpeta `screenshots/`.

## 🔧 Configuración Adicional

### Variables de Entorno

Puedes configurar el comportamiento de las pruebas usando variables de entorno:

```bash
# Ejecutar en modo visible (no headless)
HEADLESS=false npm test

# Añadir retraso entre acciones (en milisegundos)
SLOW_MO=1000 npm test
```

### Configuración de Navegadores

Por defecto se usa Chromium. Para cambiar a Firefox o Safari:

```bash
# Editar src/hooks/hooks.ts y cambiar chromium.launch() por:
# - firefox.launch() para Firefox
# - webkit.launch() para Safari
```

## 📝 Mejores Prácticas Implementadas

1. **Page Object Model (POM)**: Separación clara entre lógica de negocio y selectores de UI
2. **Custom World Tipado**: Acceso seguro a instancias de Playwright
3. **Hooks de Ciclo de Vida**: Gestión automática de recursos
4. **Captura Automática**: Screenshots en fallos
5. **TypeScript Estricto**: Tipado estático para mayor robustez
6. **Ejecución Paralela**: Optimización del tiempo de ejecución
7. **Reportes Detallados**: HTML interactivo y JSON para integración CI/CD

## 🐛 Depuración

Para depurar escenarios específicos:

1. Agrega el tag `@debug` al escenario
2. Ejecuta: `npm run test:debug`
3. Usa `console.log()` en los step definitions
4. Revisa las capturas de pantalla en `screenshots/`

## 🔄 Integración CI/CD

El proyecto está listo para integrarse con pipelines de CI/CD:

```yaml
# Ejemplo para GitHub Actions
- name: Run E2E Tests
  run: |
    npm ci
    npm run playwright:install
    npm run test:parallel
```

## 📚 Documentación Adicional

- [Playwright Documentation](https://playwright.dev/)
- [Cucumber.js Documentation](https://cucumber.io/docs/cucumber/)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)

---

**Desarrollado por**: QA Automation Engineer Senior  
**Versión**: 1.0.0  
**Última actualización**: $(date)
EOF

echo ""
echo "🎉 ¡PROYECTO CREADO EXITOSAMENTE!"
echo ""
echo "📋 Resumen de lo creado:"
echo "   ✅ Estructura de carpetas completa"
echo "   ✅ package.json con scripts configurados"
echo "   ✅ tsconfig.json con configuración estricta"
echo "   ✅ cucumber.js con soporte TypeScript"
echo "   ✅ .gitignore optimizado"
echo "   ✅ Custom World tipado"
echo "   ✅ Hooks con gestión de ciclo de vida"
echo "   ✅ Page Object de ejemplo"
echo "   ✅ Step Definitions en español"
echo "   ✅ Feature file con escenarios variados"
echo "   ✅ README.md con instrucciones completas"
echo ""
echo "🚀 Próximos pasos:"
echo "   1. Ejecuta: npm install"
echo "   2. Ejecuta: npm run playwright:install"
echo "   3. Ejecuta: npm test"
echo ""
echo "📁 Ubicación del proyecto: $(pwd)"
echo "📖 Consulta README.md para más detalles"
echo ""