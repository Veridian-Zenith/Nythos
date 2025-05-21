# Nythos Project

Nythos is an adaptive, privacy-focused AI system designed to operate within the framework of EU regulations. This project utilizes Zig for the core AI engine and is built entirely with free and open-source tools.

## Objectives

- Develop a robust AI engine capable of reasoning and executing tasks.
- Ensure compliance with EU regulations regarding data privacy and handling.
- Provide users with control over their data and privacy settings.

## Architecture

The project is structured as follows:

- **src/**: Contains the source code for the AI engine.
  - **engine/**: Core logic and functionalities of the AI.
    - `core.zig`: Implements main reasoning and execution functionalities.
    - `inference.zig`: Handles inference mechanisms for processing user queries.
    - `privacy.zig`: Manages privacy features, including data encryption.
  - **models/**: Defines the AI's knowledge representation.
    - `base.zig`: Outlines the structure and behavior of the AI's models.
  - **utils/**: Utilities for compliance and validation.
    - `compliance.zig`: Ensures compliance with EU regulations.
    - `validation.zig`: Provides validation utilities for user inputs.
  - `main.zig`: Entry point for the application.

- **tests/**: Contains unit tests for the AI engine.
  - `core_test.zig`: Tests for core functionalities.
  - `privacy_test.zig`: Tests for privacy features.

- **build.zig**: Build configurations and dependencies.

- **LICENSE**: Licensing information for the project.

## Usage

To build and run the project, use the following command:

```
zig build run
```

Ensure that you have Zig installed on your system. For more detailed instructions, refer to the documentation in each source file.