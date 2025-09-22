/** @type {import('ts-jest').JestConfigWithTsJest} **/
/*
module.exports = {
  testEnvironment: "node",
  transform: {
    "^.+.tsx?$": ["ts-jest",{}],
  },
};
*/
module.exports = {
  preset: "ts-jest",
  testEnvironment: "node",
  testMatch: ["**/test/**/*.test.ts"], // Ensure Jest looks for test files in the test directory
  // transform: {
  //   "^.+.tsx?$": ["ts-jest",{}],
  // },
  moduleNameMapper: {
    "^@/(.*)$": "<rootDir>/src/$1",
  },
};



