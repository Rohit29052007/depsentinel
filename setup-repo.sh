#!/bin/bash

# DepSentinel Repository Setup Script
# This script creates the complete directory structure and configuration files

set -e  # Exit on error

echo "🚀 Creating DepSentinel repository structure..."
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 1. Create all directories
create_dirs() {
    echo -e "${BLUE}📁 Creating directory structure...${NC}"
    
    # Core directories
    mkdir -p .github/workflows
    mkdir -p cli/src/commands
    mkdir -p core/src/{analysis,prediction,fix-generation}
    mkdir -p integrations/{github-app,gitlab-app,vscode-extension,ui}
    mkdir -p agents/{javascript,python,java,go,rust,docker}
    mkdir -p ui/{app/components,app/pages,api,public}
    mkdir -p server/src/{api,auth,db,jobs,services}
    mkdir -p shared/{types,config,schemas,utils}
    mkdir -p data/{collectors,processors,models,scripts}
    mkdir -p docs/{api,integrations,examples,architecture}
    mkdir -p tests/{e2e,integration}
    mkdir -p examples/{basic-js-project,multi-language-project}
    mkdir -p scripts
    
    echo -e "${GREEN}✅ Directories created${NC}"
}

# 2. Create root package.json
create_root_package() {
    echo -e "${BLUE}📦 Creating root package.json...${NC}"
    
    cat > package.json << 'EOF'
{
  "name": "depsentinel",
  "version": "1.0.0",
  "description": "AI-powered dependency management and security monitoring platform",
  "private": true,
  "workspaces": [
    "cli",
    "core",
    "integrations",
    "agents",
    "ui",
    "server",
    "shared"
  ],
  "scripts": {
    "build": "npm run build --workspaces",
    "test": "npm run test --workspaces",
    "lint": "eslint . --ext .ts,.tsx",
    "lint:fix": "eslint . --ext .ts,.tsx --fix",
    "format": "prettier --write \"**/*.{ts,tsx,json,md}\"",
    "format:check": "prettier --check \"**/*.{ts,tsx,json,md}\"",
    "typecheck": "tsc --noEmit",
    "clean": "npm run clean --workspaces && rm -rf node_modules",
    "dev": "npm run dev --workspace=cli",
    "docker:up": "docker-compose up -d",
    "docker:down": "docker-compose down",
    "docker:logs": "docker-compose logs -f"
  },
  "keywords": [
    "dependency-management",
    "security",
    "ai",
    "monorepo",
    "typescript"
  ],
  "author": "",
  "license": "MIT",
  "devDependencies": {
    "@types/jest": "^29.5.12",
    "@types/node": "^20.11.19",
    "@typescript-eslint/eslint-plugin": "^7.0.1",
    "@typescript-eslint/parser": "^7.0.1",
    "eslint": "^8.56.0",
    "eslint-config-prettier": "^9.1.0",
    "eslint-plugin-import": "^2.29.1",
    "jest": "^29.7.0",
    "prettier": "^3.2.5",
    "ts-jest": "^29.1.2",
    "ts-node": "^10.9.2",
    "typescript": "^5.3.3"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=9.0.0"
  }
}
EOF
    
    echo -e "${GREEN}✅ Root package.json created${NC}"
}

# 3. Create TypeScript configuration
create_tsconfig() {
    echo -e "${BLUE}📝 Creating tsconfig.json...${NC}"
    
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "lib": ["ES2022"],
    "moduleResolution": "node",
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "outDir": "./dist",
    "rootDir": "./",
    "composite": true,
    "incremental": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "paths": {
      "@depsentinel/core": ["./core/src"],
      "@depsentinel/cli": ["./cli/src"],
      "@depsentinel/integrations": ["./integrations/src"],
      "@depsentinel/agents": ["./agents/src"],
      "@depsentinel/ui": ["./ui"],
      "@depsentinel/server": ["./server/src"],
      "@depsentinel/shared": ["./shared"]
    }
  },
  "exclude": [
    "node_modules",
    "dist",
    "build",
    "**/*.spec.ts",
    "**/*.test.ts"
  ]
}
EOF
    
    echo -e "${GREEN}✅ tsconfig.json created${NC}"
}

# 4. Create .gitignore
create_gitignore() {
    echo -e "${BLUE}🚫 Creating .gitignore...${NC}"
    
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
package-lock.json
yarn.lock
pnpm-lock.yaml

# Build outputs
dist/
build/
*.tsbuildinfo

# Environment variables
.env
.env.local
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Testing
coverage/
*.lcov
.nyc_output/

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*

# Docker
.docker/
*.pid
*.seed
*.pid.lock

# Temporary files
tmp/
temp/
*.tmp

# OS
Thumbs.db
.DS_Store
EOF
    
    echo -e "${GREEN}✅ .gitignore created${NC}"
}

# 5. Create Docker Compose
create_docker_compose() {
    echo -e "${BLUE}🐳 Creating docker-compose.yml...${NC}"
    
    cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  postgres:
    image: postgres:16-alpine
    container_name: depsentinel-postgres
    environment:
      POSTGRES_DB: depsentinel
      POSTGRES_USER: depsentinel
      POSTGRES_PASSWORD: depsentinel_dev
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./data/init.sql:/docker-entrypoint-initdb.d/init.sql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U depsentinel"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: depsentinel-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: depsentinel-app
    environment:
      NODE_ENV: development
      DATABASE_URL: postgresql://depsentinel:depsentinel_dev@postgres:5432/depsentinel
      REDIS_URL: redis://redis:6379
    ports:
      - "3000:3000"
    volumes:
      - .:/app
      - /app/node_modules
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    command: npm run dev

volumes:
  postgres_data:
  redis_data:
EOF
    
    echo -e "${GREEN}✅ docker-compose.yml created${NC}"
}

# 6. Create workspace package.json files
create_workspace_packages() {
    echo -e "${BLUE}📦 Creating workspace package.json files...${NC}"
    
    # CLI package
    cat > cli/package.json << 'EOF'
{
  "name": "@depsentinel/cli",
  "version": "1.0.0",
  "description": "DepSentinel command-line interface",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "bin": {
    "depsentinel": "./dist/cli.js",
    "ds": "./dist/cli.js"
  },
  "scripts": {
    "build": "tsc",
    "dev": "ts-node src/cli.ts",
    "test": "jest",
    "clean": "rm -rf dist"
  },
  "dependencies": {
    "@depsentinel/core": "*",
    "commander": "^12.0.0",
    "chalk": "^4.1.2",
    "ora": "^5.4.1",
    "inquirer": "^8.2.6"
  },
  "devDependencies": {
    "@types/inquirer": "^9.0.7"
  }
}
EOF

    # Core package
    cat > core/package.json << 'EOF'
{
  "name": "@depsentinel/core",
  "version": "1.0.0",
  "description": "DepSentinel core library",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "test": "jest",
    "clean": "rm -rf dist"
  },
  "dependencies": {
    "pg": "^8.11.3",
    "redis": "^4.6.13",
    "dotenv": "^16.4.1",
    "zod": "^3.22.4",
    "winston": "^3.11.0"
  },
  "devDependencies": {
    "@types/pg": "^8.11.0"
  }
}
EOF

    # Integrations package
    cat > integrations/package.json << 'EOF'
{
  "name": "@depsentinel/integrations",
  "version": "1.0.0",
  "description": "DepSentinel integrations with external services",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "test": "jest",
    "clean": "rm -rf dist"
  },
  "dependencies": {
    "@depsentinel/core": "*",
    "@octokit/rest": "^20.0.2",
    "axios": "^1.6.7"
  }
}
EOF

    # Agents package
    cat > agents/package.json << 'EOF'
{
  "name": "@depsentinel/agents",
  "version": "1.0.0",
  "description": "Language-specific dependency analysis agents",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "test": "jest",
    "clean": "rm -rf dist"
  },
  "dependencies": {
    "@depsentinel/core": "*",
    "@depsentinel/shared": "*"
  }
}
EOF

    # UI package
    cat > ui/package.json << 'EOF'
{
  "name": "@depsentinel/ui",
  "version": "1.0.0",
  "description": "DepSentinel web dashboard",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "test": "jest"
  },
  "dependencies": {
    "@depsentinel/shared": "*",
    "next": "^14.1.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.55",
    "@types/react-dom": "^18.2.19"
  }
}
EOF

    # Server package
    cat > server/package.json << 'EOF'
{
  "name": "@depsentinel/server",
  "version": "1.0.0",
  "description": "DepSentinel API server",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "dev": "ts-node-dev --respawn src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "jest",
    "clean": "rm -rf dist"
  },
  "dependencies": {
    "@depsentinel/core": "*",
    "@depsentinel/shared": "*",
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^7.1.0",
    "express-rate-limit": "^7.1.5"
  },
  "devDependencies": {
    "@types/express": "^4.17.21",
    "@types/cors": "^2.8.17",
    "ts-node-dev": "^2.0.0"
  }
}
EOF

    # Shared package
    cat > shared/package.json << 'EOF'
{
  "name": "@depsentinel/shared",
  "version": "1.0.0",
  "description": "Shared types, schemas, and utilities",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "test": "jest",
    "clean": "rm -rf dist"
  },
  "dependencies": {
    "zod": "^3.22.4"
  }
}
EOF
    
    echo -e "${GREEN}✅ Workspace packages created${NC}"
}

# 7. Create code quality configuration files
create_quality_configs() {
    echo -e "${BLUE}🔧 Creating code quality configs...${NC}"
    
    # ESLint
    cat > .eslintrc.json << 'EOF'
{
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": 2022,
    "sourceType": "module",
    "project": "./tsconfig.json"
  },
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-requiring-type-checking",
    "plugin:import/recommended",
    "plugin:import/typescript",
    "prettier"
  ],
  "plugins": ["@typescript-eslint", "import"],
  "rules": {
    "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    "@typescript-eslint/explicit-function-return-type": "off",
    "@typescript-eslint/explicit-module-boundary-types": "off",
    "@typescript-eslint/no-explicit-any": "warn",
    "import/order": [
      "error",
      {
        "groups": [
          "builtin",
          "external",
          "internal",
          "parent",
          "sibling",
          "index"
        ],
        "newlines-between": "always",
        "alphabetize": {
          "order": "asc",
          "caseInsensitive": true
        }
      }
    ]
  },
  "settings": {
    "import/resolver": {
      "typescript": {
        "alwaysTryTypes": true,
        "project": "./tsconfig.json"
      }
    }
  }
}
EOF

    # Prettier
    cat > .prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "arrowParens": "always",
  "endOfLine": "lf"
}
EOF

    # Jest
    cat > jest.config.js << 'EOF'
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
EOF
    
    echo -e "${GREEN}✅ Code quality configs created${NC}"
}

# 8. Create GitHub Actions workflows
create_github_workflows() {
    echo -e "${BLUE}⚙️  Creating GitHub Actions workflows...${NC}"
    
    # CI workflow
    cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  lint:
    name: Lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run ESLint
        run: npm run lint
      
      - name: Check formatting
        run: npm run format:check

  typecheck:
    name: Type Check
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run TypeScript compiler
        run: npm run typecheck

  test:
    name: Test
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18, 20]
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
      
      - name: Upload coverage
        if: matrix.node-version == 20
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info

  build:
    name: Build
    runs-on: ubuntu-latest
    needs: [lint, typecheck, test]
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build all workspaces
        run: npm run build
      
      - name: Upload build artifacts
        uses: actions/upload-artifact@v4
        with:
          name: build-artifacts
          path: |
            cli/dist
            core/dist
            integrations/dist
EOF

    # Release workflow
    cat > .github/workflows/release.yml << 'EOF'
name: Release

on:
  push:
    tags:
      - 'v*.*.*'

jobs:
  release:
    name: Create Release
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build
        run: npm run build
      
      - name: Run tests
        run: npm test
      
      - name: Extract version from tag
        id: version
        run: echo "VERSION=${GITHUB_REF#refs/tags/v}" >> $GITHUB_OUTPUT
      
      - name: Create GitHub Release
        uses: softprops/action-gh-release@v1
        with:
          generate_release_notes: true
          files: |
            cli/dist/**
            core/dist/**
            integrations/dist/**
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  docker:
    name: Build and Push Docker Image
    runs-on: ubuntu-latest
    permissions:
      packages: write
      contents: read
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Log in to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ghcr.io/${{ github.repository }}
          tags: |
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=semver,pattern={{major}}
            type=sha
      
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
EOF
    
    echo -e "${GREEN}✅ GitHub workflows created${NC}"
}

# 9. Create README
create_readme() {
    echo -e "${BLUE}📚 Creating README.md...${NC}"
    
    cat > README.md << 'EOF'
# DepSentinel 🛡️

> AI-powered dependency management and security monitoring platform

[![CI](https://github.com/yourusername/depsentinel/actions/workflows/ci.yml/badge.svg)](https://github.com/yourusername/depsentinel/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

DepSentinel is a comprehensive dependency management and security monitoring platform that leverages AI to help development teams maintain secure and up-to-date dependencies across their projects.

### Key Features

- 🔍 **Automated Dependency Scanning** - Continuously monitor dependencies for security vulnerabilities
- 🤖 **AI-Powered Analysis** - Intelligent recommendations for dependency updates and security patches
- 🔄 **Multi-Platform Support** - Works with npm, yarn, pip, maven, and more
- 📊 **Comprehensive Reporting** - Detailed insights into your dependency landscape
- 🔔 **Real-time Alerts** - Get notified immediately about critical security issues
- 🐳 **Docker Support** - Easy local development with containerized services

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/depsentinel.git
cd depsentinel

# Install dependencies
npm install

# Start Docker services
npm run docker:up

# Build the project
npm run build

# Run tests
npm test
```

## Architecture

DepSentinel is built as a TypeScript monorepo with the following workspaces:

- **`cli/`** - Command-line interface
- **`core/`** - Core library with business logic
- **`integrations/`** - External service integrations
- **`agents/`** - Language-specific analysis agents
- **`ui/`** - Next.js web dashboard
- **`server/`** - Express REST API
- **`shared/`** - Common types and utilities

## Development

```bash
# Start development servers
npm run dev --workspace=ui        # UI on port 3000
npm run dev --workspace=server    # Server on port 3000
npm run dev --workspace=cli       # CLI in watch mode

# Run linting
npm run lint

# Format code
npm run format
```

## License

MIT
EOF
    
    echo -e "${GREEN}✅ README.md created${NC}"
}

# 10. Initialize Git repository
init_git() {
    echo -e "${BLUE}🔧 Initializing Git repository...${NC}"
    
    if [ ! -d ".git" ]; then
        git init
        git add .
        git commit -m "Initial commit: DepSentinel repository structure"
        echo -e "${GREEN}✅ Git repository initialized${NC}"
    else
        echo -e "${GREEN}✅ Git repository already exists${NC}"
    fi
}

# Main execution
main() {
    create_dirs
    create_root_package
    create_tsconfig
    create_gitignore
    create_docker_compose
    create_workspace_packages
    create_quality_configs
    create_github_workflows
    create_readme
    init_git
    
    echo ""
    echo -e "${GREEN}🎉 DepSentinel repository structure created successfully!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Run: git remote add origin https://github.com/YOUR_USERNAME/depsentinel.git"
    echo "2. Run: git push -u origin main"
    echo "3. Install dependencies: npm install"
    echo "4. Start development!"
    echo ""
}

# Run the script
main
