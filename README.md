# 🚀 Developer Companion

An AI-first, gamified developer tracking platform built with a distributed microkernel architecture. 

This platform acts as a unified hub for developers, transforming coding practice (DSA), project management, and resume building into an automated, gamified experience powered by AI and robust data pipelines.

## 🏗️ Architecture at a Glance

This project demonstrates enterprise-grade distributed systems, polyglot microservices, and applied AI.

*   **Frontend:** Angular + Nx Workspace (Micro-frontend ready, lazy-loaded domain modules).
*   **Backend Core:** Spring Boot (Hexagonal / Clean Architecture) + Spring Cloud Gateway.
*   **Data Pipeline:** Kafka (Event Mesh), Apache Airflow, Apache Spark, Debezium (CDC).
*   **Applied AI:** Python (FastAPI) microservice utilizing `pgvector` for RAG and predictive knowledge-decay modeling.
*   **Infrastructure:** PostgreSQL (Citus/Sharding), Redis Cluster, Docker Compose.
*   **Data Collection:** Custom Browser Extension (TypeScript) for platform-agnostic DOM/Network scraping.


## 📂 Repository Structure

We utilize a strict modular monorepo to isolate domains and allow contributors to run only what they need.

| Directory | Purpose |
| :--- | :--- |
| `/apps` | Angular Host Application (Web Shell, Admin Portal) |
| `/libs` | Isolated Frontend Plugins (DSA Tracker, Resume Builder) |
| `/services` | Backend Microservices (Spring Boot Core, Python AI Agent) |
| `/data-pipelines` | Apache Airflow DAGs & PySpark Aggregation Jobs |
| `/infrastructure` | Docker Compose profiles (`minimal`, `data-eng`, `full`) |
| `/docs/architecture` | Low-Level Design (LLD) and System Blueprints |

## 🛠️ Quick Start (Local Development)

To ensure a frictionless developer experience, you can boot the environment using targeted Docker profiles.

1. Clone the repository:
   \`\`\`bash
   git clone https://github.com/akotkaryash/developer-companion.git
   cd developer-companion
   \`\`\`
2. Boot the minimal backend (PostgreSQL, Redis, Core Gamification Service):
   \`\`\`bash
   docker-compose --profile minimal up -d
   \`\`\`
3. Start the Angular UI:
   \`\`\`bash
   npx nx serve
   \`\`\`

## 🤝 Contributing
We welcome contributions! Please see our [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines on how to build plugins, run the local data pipelines, and submit Pull Requests.

## 📄 License
This project is licensed under the [MIT License](./LICENSE).