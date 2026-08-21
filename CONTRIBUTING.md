# Contributing to Developer Companion

Thank you for your interest in contributing! This project is built as a modular monorepo, allowing you to focus strictly on the area you care about.

---

## 🎯 Contributor Tracks

Select the track that matches your focus to run an isolated local environment:

### Track 1: Frontend & UI (Angular / Nx)
* **Prerequisites:** Node.js 20+, npm
* **Workflow:** Work inside `/apps` or `/libs` using mock backends without running Java or Docker.
* **Run:**
  \`\`\`bash
  npx nx serve web-shell --mock-backend
  \`\`\`

### Track 2: Backend & Microservices (Spring Boot / Python AI)
* **Prerequisites:** Java 21+, Python 3.11+, Docker Desktop
* **Workflow:** Spin up only core backing infrastructure and run your targeted microservice locally.
* **Run:**
  \`\`\`bash
  # Boot minimal core dependencies
  docker-compose --profile minimal up -d

  # Run the core service via Maven
  ./mvnw spring-boot:run -pl services/core-gamification
  \`\`\`

### Track 3: Data Engineering & Analytics (Kafka, Spark, Airflow)
* **Prerequisites:** Docker Desktop, Python 3.11+
* **Workflow:** Work in `/data-pipelines` using synthetic event generators without spinning up the frontend.
* **Run:**
  \`\`\`bash
  docker-compose --profile data-eng up -d
  \`\`\`

---

## 📋 Pull Request (PR) Process

1. Fork the repository and create a feature branch (`feature/issue-number-description`).
2. Keep changes scoped strictly to your domain folder (`/apps`, `/libs`, `/services`, or `/data-pipelines`).
3. Ensure existing tests pass and add unit tests for any new business logic.
4. Open a Pull Request referencing the corresponding GitHub Issue (e.g., `Closes #123`).