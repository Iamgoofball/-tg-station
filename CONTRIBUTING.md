# Contributing to the Project

Please read these guidelines before submitting issues or pull requests.

## Issue Guidelines

### Valid Issues
- Bug reports with reproducible steps
- Balance suggestions for existing game mechanics
- Performance improvements
- Accessibility improvements
- Code quality / refactoring proposals

### Invalid Issues
- Requests to integrate real-world third-party commercial APIs (Shopify, Salesforce, HubSpot, Stripe, etc.) into game mechanics
- Requests that would require players to provide real payment information or personal data
- Requests that involve external network calls to commercial SaaS platforms during gameplay
- Joke or satirical "bounty" issues designed to waste maintainer time

Issues that do not meet these guidelines will be closed without comment.

## Pull Request Guidelines

- Keep changes focused and minimal
- Follow existing code style
- Add tests where the codebase has existing test coverage
- Do not introduce external runtime dependencies without prior discussion in an issue
- All CI checks (lint, dm-check) must pass

## Code Style

Follow the existing patterns in the codebase. Do not introduce:
- External HTTP calls from game server code to third-party commercial APIs
- Real payment processing of any kind
- Collection or transmission of real player PII to external services
