# 🌱 Full Kit

[![Release](https://github.com/nom-nom-hub/full-kit/actions/workflows/release.yml/badge.svg)](https://github.com/nom-nom-hub/full-kit/actions/workflows/release.yml)
[![GitHub Pages](https://img.shields.io/badge/docs-GitHub_Pages-blue)](https://nom-nom-hub.github.io/full-kit/)

**Goal-Driven, Blueprint-Driven & Spec-Driven Development (GDD, BDD, SDD) in One Toolkit**

Full Kit is an innovative development toolkit that combines three powerful methodologies:

- **Goal-Driven Development (GDD)** - Focus on high-level business objectives and outcomes
- **Blueprint-Driven Development (BDD)** - Emphasize architectural planning and system design  
- **Spec-Driven Development (SDD)** - Detailed specifications that generate working implementations

## 🚀 Get Started

### 1. Install Full Kit

Choose your preferred installation method:

#### Option 1: Persistent Installation (Recommended)

Install once and use everywhere:

```bash
uv tool install fullkit-cli --from git+https://github.com/nom-nom-hub/full-kit.git
```

Then use the tool directly:

```bash
fullkit init <PROJECT_NAME>
fullkit check
```

#### Option 2: One-time Usage

Run directly without installing:

```bash
uvx --from git+https://github.com/nom-nom-hub/full-kit.git fullkit init <PROJECT_NAME>
```

### 2. Choose Your Development Path

Full Kit supports three methodologies:

#### Goal-Driven Development
- `/fullkit.goal` - Define high-level business objectives and outcomes
- `/fullkit.outcomes` - Track and measure results

#### Blueprint-Driven Development  
- `/fullkit.blueprint` - Create architectural blueprints and system designs
- `/fullkit.design` - Generate technical implementation plans

#### Spec-Driven Development (from Spec Kit)
- `/fullkit.specify` - Create detailed functional specifications
- `/fullkit.plan` - Generate technical implementation plans
- `/fullkit.tasks` - Break down implementation into actionable tasks
- `/fullkit.implement` - Execute implementation according to plan

### 3. Integrated Workflow

Use all three methodologies together for maximum effectiveness:

1. **Start with Goals**: Define what you want to achieve (`/fullkit.goal`)
2. **Design the Architecture**: Plan how to achieve it (`/fullkit.blueprint`) 
3. **Create Specifications**: Detail the implementation (`/fullkit.specify`)
4. **Implement**: Execute the plan (`/fullkit.implement`)

## 📚 Methodology Overview

### Goal-Driven Development (GDD)

Focuses on business outcomes and objectives rather than implementation details. GDD asks:
- What are we trying to achieve?
- How will we measure success?
- What business value does this create?

### Blueprint-Driven Development (BDD)

Emphasizes architectural planning and system design. BDD addresses:
- How should the system be structured?
- What patterns and principles should guide the design?
- What are the key architectural decisions?

### Spec-Driven Development (SDD) 

Detailed specifications that generate working implementations. SDD ensures:
- Specifications become executable and generate code
- Traceability between requirements and implementation
- Consistency and quality across the codebase

## 🔧 Prerequisites

- **Linux/macOS/Windows**
- Supported AI coding agent
- [uv](https://docs.astral.sh/uv/) for package management
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

## 📄 License

This project is licensed under the terms of the MIT open source license.