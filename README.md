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
# FlorTest_FIFAPLUS
Este es un proyecto de prueba 
