module.exports = {
    preset: 'ts-jest',
    testEnvironment: 'node',
    roots: ['<rootDir>'],
    testMatch: ['**/__tests__/**/*.ts', '**/?(*.)+(spec|test).ts'],
    transform: {
        '^.+\\.ts$': 'ts-jest',
    },
    collectCoverageFrom: [
        '**/*.ts',
        '!**/*.d.ts',
        '!**/node_modules/**',
        '!**/dist/**',
        '!**/build/**',
    ],
    coverageThreshold: {
        global: {
            branches: 70,
            functions: 70,
            lines: 70,
            statements: 70,
        },
    },
    moduleNameMapper: {
        '^@depsentinel/core$': '<rootDir>/core/src',
        '^@depsentinel/cli$': '<rootDir>/cli/src',
        '^@depsentinel/integrations$': '<rootDir>/integrations/src',
        '^@depsentinel/agents$': '<rootDir>/agents/src',
    },
    moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node'],
};
