module.exports = {
  default: {
    require:[
      "src/steps/*.ts",
      "src/hooks/*.ts"
    ],
    requireModule: ['ts-node/register'],
    format: [
      'progress',
      'json:reports/cucumber-report.json'
    ],
    paths: [
      "features/*.feature"
    ]
  }
};
