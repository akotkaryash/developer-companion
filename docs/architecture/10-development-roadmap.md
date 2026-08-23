# Development Roadmap & Execution Plan

## 1. Core Philosophy
This project adheres to strict Agile methodologies and iterative development. No business logic or infrastructure will be implemented without first establishing the appropriate architectural diagrams (C4 Model) and API/Event contracts.

## 2. Phase 1: Monorepo Initialization (Skeletons)
Before infrastructure is built, all domain boundaries must exist as empty shells.
*   **Frontend:** Angular (Nx Workspace) initialization.
*   **Backend:** Spring Boot Core Gamification (Completed).
*   **AI Agent:** Python FastAPI skeleton.
*   **Data Pipeline:** Apache Airflow and PySpark directory structures.
*   **Ingestion:** Browser Extension (TypeScript) worker and script shells.

## 3. Phase 2: Architectural Diagramming (C4 Model)
Moving from high-level to granular low-level design (LLD).
*   **Level 1 (System Context):** Completed.
*   **Level 2 (Container):** Network boundaries between Gateway, Services, and DBs.
*   **Level 3 (Component):** Clean Architecture boundaries within Spring Boot and Python.
*   **Level 4 (Sequence):** Step-by-step data flow from extension DOM scraping to Kafka events.
*   **Level 5 (Database & Contracts):** ER Diagrams, JSON API payloads, and Kafka topic schemas.

## 4. Phase 3: Infrastructure & CI/CD
*   **Local Docker Profiles:** Building `docker-compose.yml` for `minimal`, `data-eng`, and `full` setups to ensure developers can run isolated environments.
*   **GitHub Actions:** Implementing automated linting, testing, and branch protection rules for PRs.

## 5. Phase 4: Agile Execution (The Epics)
Once Phases 1-3 are locked, development begins sequentially via tracked GitHub Issues:
*   **Epic 1:** Foundation (Phases 1-3)
*   **Epic 2:** System LLD & Contracts
*   **Epic 3:** Browser Extension (Data Ingestion)
*   **Epic 4:** Core Gamification Engine (Spring Boot)
*   **Epic 5:** Data Engineering Pipeline (Debezium, Spark, Airflow)
*   **Epic 6:** Applied AI Agent (FastAPI, pgvector)