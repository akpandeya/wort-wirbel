# AI Copilot Instructions: Coding Standards & Philosophy

This document outlines the core principles for generating code in this repository. Adhere to these guidelines to ensure consistency, quality, and maintainability.

---

## 1. Code Style & Documentation

**Principle**: Code must be self-documenting. Clarity and readability are the highest priorities.

* **Naming Conventions**: Use descriptive, unambiguous names for variables, functions, classes, and modules. The name should clearly communicate its purpose without needing a comment.
* **Function Design**: Keep functions short and focused on a single responsibility (Single Responsibility Principle). A function should do one thing and do it well.
* **Comments**:
    * **AVOID obvious comments**. Do not write comments that explain *what* the code is doing if it's clear from the code itself (e.g., `// a for-loop to iterate over products`).
    * **DO write comments to explain the *why***. If a piece of code implements complex business logic, a non-obvious performance optimization, or a workaround for a specific issue, add a comment to explain the reasoning and context.

---

## 2. Development Methodology: Test-Driven Development (TDD)

**Principle**: Tests define and verify behavior before implementation.

* **Default Workflow**: When tasked with creating a new feature, function, or class, always follow the Red-Green-Refactor cycle:
    1.  **Red (Write a Failing Test)**: First, generate the test file and write a concise, failing test case that clearly defines the requirements and expected outcome of the new functionality.
    2.  **Green (Make the Test Pass)**: Next, write the simplest possible implementation code required to make the test pass. Do not add extra functionality.
    3.  **Refactor (Improve the Code)**: Finally, refactor the implementation code for clarity, performance, and style while ensuring all tests continue to pass.
* **Test Coverage**: Prioritize creating unit and integration tests for all business logic, especially within the domain layer.

---

## 3. Architectural Philosophy: Domain-Driven Design (DDD)

**Principle**: The software's structure and language should be based on the business domain.

* **Layered Architecture**: Structure the application into distinct layers (e.g., **Domain**, **Application**, **Infrastructure**, **Presentation/UI**). Maintain strict boundaries and direct dependencies inward toward the domain layer.
* **Domain Modeling**: When generating code for the core logic, use DDD patterns to create a rich and expressive model:
    * **Entities**: Define objects by their distinct identity and lifecycle (e.g., `User`, `Order`).
    * **Value Objects**: Use immutable objects for descriptive aspects of the domain where identity is not important (e.g., `Address`, `Money`).
    * **Aggregates**: Group related entities and value objects into a consistency boundary, with a single entry point (the **Aggregate Root**).
    * **Repositories**: Define interfaces in the domain layer for persisting and retrieving aggregates. Place the concrete implementations in the infrastructure layer.
    * **Domain Services**: Implement core domain logic that doesn't naturally fit within an entity or value object.
* **Ubiquitous Language**: Use the language of the domain experts directly in the code. Class names, methods, and variables should reflect the official terminology of the business domain.
