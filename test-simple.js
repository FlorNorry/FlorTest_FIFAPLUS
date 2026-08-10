const { spawn } = require('child_process');
const path = require('path');

console.log('🚀 Iniciando pruebas con configuración simplificada...');

// Ejecutar cucumber con configuración básica
const cucumber = spawn('npx', [
  'cucumber-js',
  '--require-module', 'ts-node/register',
  '--require', 'src/hooks/hooks.ts',
  '--require', 'src/steps/*.ts',
  '--format', 'pretty',
  '--format', 'json:reports/cucumber-report.json',
  '--format', 'html:reports/cucumber-report.html'
], {
  stdio: 'inherit',
  cwd: __dirname,
  env: {
    ...process.env,
    TS_NODE_PROJECT: './tsconfig-node.json'
  }
});

cucumber.on('close', (code) => {
  console.log(`\n📊 Proceso finalizado con código: ${code}`);
  if (code === 0) {
    console.log('✅ Todas las pruebas se ejecutaron correctamente');
  } else {
    console.log('❌ Algunas pruebas fallaron o hubo errores');
  }
});

cucumber.on('error', (error) => {
  console.error('❌ Error al ejecutar cucumber:', error.message);
  process.exit(1);
});