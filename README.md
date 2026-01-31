# DepSentinel

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

## Architecture

DepSentinel is built as a TypeScript monorepo with the following workspaces:

- **`cli/`** - Command-line interface for interacting with DepSentinel
- **`core/`** - Core library with business logic and data models
- **`integrations/`** - External service integrations (GitHub, GitLab, etc.)
- **`agents/`** - AI agents for dependency analysis and recommendations

## Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** >= 18.0.0
- **npm** >= 9.0.0
- **Docker** and **Docker Compose** (for local development)
- **Git**

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/depsentinel.git
cd depsentinel
```

### 2. Install Dependencies

```bash
npm install
```

This will install dependencies for all workspace packages.

### 3. Set Up Environment Variables

Copy the example environment file and configure it:

```bash
cp .env.example .env
```

Edit `.env` with your configuration:

```env
DATABASE_URL=postgresql://depsentinel:depsentinel_dev@localhost:5432/depsentinel
REDIS_URL=redis://localhost:6379
NODE_ENV=development
```

### 4. Start Local Services with Docker

```bash
npm run docker:up
```

This will start PostgreSQL and Redis services in Docker containers.

### 5. Build the Project

```bash
npm run build
```

## Usage

### CLI Commands

Once installed, you can use the DepSentinel CLI:

```bash
# Scan a project for dependency vulnerabilities
npx depsentinel scan

# Check for available updates
npx depsentinel check-updates

# Generate a security report
npx depsentinel report

# Interactive mode
npx depsentinel
```

### Development

#### Run in Development Mode

```bash
npm run dev
```

#### Run Tests

```bash
npm test
```

#### Lint Code

```bash
npm run lint
```

#### Format Code

```bash
npm run format
```

#### Type Check

```bash
npm run typecheck
```

## Docker Development

### Start All Services

```bash
docker-compose up -d
```

### View Logs

```bash
npm run docker:logs
```

### Stop Services

```bash
npm run docker:down
```

## Project Structure

```
depsentinel/
├── cli/                    # CLI application
│   ├── src/
│   └── package.json
├── core/                   # Core library
│   ├── src/
│   └── package.json
├── integrations/           # External integrations
│   ├── src/
│   └── package.json
├── agents/                 # AI agents
│   ├── src/
│   └── package.json
├── .github/
│   └── workflows/          # CI/CD workflows
├── docs/                   # Documentation
├── tests/                  # Integration tests
├── docker-compose.yml      # Docker services
├── package.json            # Root package.json
└── tsconfig.json           # TypeScript configuration
```

## Scripts

| Script | Description |
|--------|-------------|
| `npm run build` | Build all workspace packages |
| `npm test` | Run tests across all workspaces |
| `npm run lint` | Lint all TypeScript files |
| `npm run lint:fix` | Fix linting issues automatically |
| `npm run format` | Format code with Prettier |
| `npm run format:check` | Check code formatting |
| `npm run typecheck` | Run TypeScript type checking |
| `npm run clean` | Clean build artifacts |
| `npm run dev` | Run CLI in development mode |
| `npm run docker:up` | Start Docker services |
| `npm run docker:down` | Stop Docker services |
| `npm run docker:logs` | View Docker logs |

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Write tests for new features
- Follow the existing code style (enforced by ESLint and Prettier)
- Update documentation as needed
- Ensure all tests pass before submitting PR

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📧 Email: support@depsentinel.dev
- 💬 Discord: [Join our community](https://discord.gg/depsentinel)
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/depsentinel/issues)

## Acknowledgments

Built with ❤️ by the DepSentinel team.
