# Development Roadmap & Execution Plan

## 1. Core Philosophy
This project adheres to strict Agile methodologies and iterative development. No business logic or infrastructure will be implemented without first establishing the appropriate architectural diagrams (C4 Model), API/Event contracts, and — for significant decisions — an Architecture Decision Record (ADR). Every piece of work must be deployable and observable as it's built; nothing is added that can't be run or seen until some larger, unrelated whole is finished.

## 2. Phase 1: Monorepo Initialization (Skeletons)
Before infrastructure is built, all domain boundaries must exist as empty shells.
*   **Frontend:** Angular (Nx Workspace) initialization.
*   **Backend:** Spring Boot Core Gamification (Completed).
*   **AI Agent:** Python FastAPI skeleton.
*   **Data Pipeline:** Apache Airflow and PySpark directory structures.
*   **Ingestion:** Browser Extension (TypeScript) worker and script shells.

**Status: Complete.**

## 3. Phase 2: Architectural Diagramming (C4 Model) & Decision Records
Moving from high-level to granular low-level design (LLD).
*   **Level 1 (System Context):** Completed.
*   **Level 2 (Container):** Network boundaries between Gateway, Services, and DBs. Completed.
*   **Level 3 (Component):** Clean Architecture boundaries within Spring Boot and Python. In progress.
*   **Level 4 (Sequence):** Step-by-step data flow from extension DOM scraping to Kafka events. In progress.
*   **Level 5 (Database & Contracts):** ER Diagrams, JSON API payloads, and Kafka topic schemas. In progress.
*   **Architecture Decision Records (ADRs):** Short `docs/architecture/decisions/ADR-NNNN-title.md` records capturing context, the decision, alternatives considered, and consequences for every significant architectural choice — both retroactively (Clean + Microkernel architecture, Kafka as the event mesh, Oracle Free Tier as the zero-cost production target) and going forward for every future major decision (e.g. the contract-first service integration strategy in Phase 4/Epic 3). This is now a standing practice, not a one-time task.

## 4. Phase 3: Infrastructure & CI/CD
*   **Local Docker Profiles:** Building `docker-compose.yml` for `minimal`, `data-eng`, and `full` setups to ensure developers can run isolated environments. Grows incrementally alongside each epic below as new infrastructure (Kafka, Redis, Keycloak, Gateway) is introduced — never added speculatively ahead of the epic that needs it.
*   **GitHub Actions:** Automated linting, testing, and branch protection rules for PRs. CI jobs (Maven/JUnit, Nx affected, Pytest) are added as each service gains real code to test.

## 5. Phase 4: Agile Execution (The Epics)

Once Phases 1-3 are locked for a given slice, development proceeds sequentially via tracked GitHub Issues (`DEV-<n>: <title>`), grouped under GitHub Milestones (one per epic). Ordering follows a deliberate "make it work, make it right, make it scale" arc: contracts and integration strategy first, then the platform/security layer everything else routes through, then the vertical slices that make the product actually function end to end, and only then a dedicated pass to harden the system for the distributed-systems depth (sharding, replication, multi-instance scaling) that is a primary goal of this project — followed by making that behavior observable and, finally, actually deployed.

*   **Epic 1: Foundation.** Empty domain skeletons for every service/app. *(Complete.)*
*   **Epic 2: LLD, Contracts & ADRs.** REST/OpenAPI contracts, internal M2M contracts, Kafka/AsyncAPI event schemas, DB schema + pgvector design (with ER diagrams), and the ADR practice defined above. *(In progress.)*
*   **Epic 3: Extensibility & Service Integration.** Defines how any backend service or frontend plugin plugs into the platform. Contract-first: the OpenAPI/AsyncAPI/JSON Schema contracts from Epic 2 are the source of truth, with typed clients generated per language, plus a thin hand-written "platform conventions" layer (auth token propagation, retries/circuit breakers, a standard health/readiness contract, structured logging conventions) for the cross-cutting concerns codegen can't produce. This epic's decisions must be captured as an ADR before Epic 4 onward builds against it.
*   **Epic 4: Platform Infra & Security.** Spring Cloud Gateway (routing, rate limiting) + Keycloak (JWT issuing, RBAC), secrets management, and dependency/SAST scanning in CI.
*   **Epic 5: Browser Extension (Data Ingestion).** Content scripts, background service worker, payload normalization, offline queueing/retry.
*   **Epic 6: Core Gamification Engine.** XP/streak/leveling engine, idempotency, optimistic locking, Kafka event publishing.
*   **Epic 7: Frontend Plugin Ecosystem.** The `libs/feature-*` Angular plugins (DSA tracker, AI coach UI, portfolio builder) and `shared-ui`, wired into `web-shell` via the SPI — this is what turns the pipeline into an actual usable product.
*   **Epic 8: Data Engineering Pipeline.** Debezium CDC, Kafka event mesh, PySpark aggregation jobs, Airflow DAG orchestration.
*   **Epic 9: Applied AI Agent.** FastAPI DSA coach, pgvector-based knowledge-decay predictor, RAG orchestration.
*   **Epic 10: Distributed Systems Hardening.** Citus sharding, Redis Cluster/replication, running multiple Core Gamification instances behind a load balancer, leader election. This is the project's primary distributed-systems learning target and is deliberately sequenced *after* the system works correctly as a single instance, not mixed into earlier epics.
*   **Epic 11: Observability & Load Testing.** Prometheus/Grafana, OpenTelemetry tracing, k6 load testing — to actually observe and measure the concurrency/throughput behavior Epic 10 introduces.
*   **Epic 12: Production Deployment (Lite).** Deploy the free-tier stack to Oracle Cloud Always Free (Docker Swarm + Traefik). Scoped explicitly as a personal/friends/contributor-demo target, not real-world production scale — the heavy distributed-systems design in Epic 10 is for learning depth, not to be paid for at scale.

**Future consideration (not a current epic):** a toned-down "production-lite" configuration/fork that could actually be offered to a wider community, once the zero-cost constraint and real hosting costs are re-evaluated.
