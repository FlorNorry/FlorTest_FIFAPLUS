module.exports = {
  default: {
    require:[
      "src/steps/*.ts",
      "src/hooks/*.ts"
    ],
    requireModule: ['ts-node/register'],
    format: [
      'progress',
      'json:reports/cucumber-report.json',
      'html:reports/cucumber-report.html',
      'allure-cucumberjs/reporter'
    ],
    formatOptions: {
      resultsDir: 'allure-results',
      labels: [
        { pattern: [/@epic:(.*)/], name: 'epic' },
        { pattern: [/@feature:(.*)/], name: 'feature' },
        { pattern: [/@story:(.*)/], name: 'story' },
        { pattern: [/@severity:(.*)/], name: 'severity' },
        { pattern: [/@owner:(.*)/], name: 'owner' }
      ],
      links: {
        issue: {
          pattern: [/@issue:(.*)/],
          urlTemplate: 'https://jira.example.com/browse/%s',
          nameTemplate: 'ISSUE %s'
        },
        tms: {
          pattern: [/@tms:(.*)/],
          urlTemplate: 'https://tms.example.com/%s'
        }
      },
      environmentInfo: {
        base_url: process.env.BASE_URL || 'https://www.fifa.com/en',
        browser: 'chromium',
        headless: process.env.HEADLESS || 'true',
        node_version: process.version,
        os_platform: process.platform
      }
    },
    paths: [
      "features/*.feature"
    ]
  }
};
