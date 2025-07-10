---

# 🧠 Nythos Project

**Nythos** is an adaptive, privacy-focused AI system designed to operate within the framework of **EU regulations**.
Built using the **Zig** programming language and entirely free and open-source tools, Nythos prioritizes **user control**, **transparency**, and **data privacy**.

---

## 🎯 Objectives

* Build a robust AI engine with task execution and reasoning capabilities
* Ensure strict compliance with **GDPR** and other EU data privacy laws
* Empower users with granular control over their data and privacy settings

---

## 🏗️ Architecture Overview

The project is structured as follows:

```
/src
├── engine/
│   ├── core.zig         # Core reasoning & task execution
│   ├── inference.zig    # Query inference logic
│   └── privacy.zig      # Data protection and encryption
│
├── models/
│   └── base.zig         # Knowledge structure and model definitions
│
├── utils/
│   ├── compliance.zig   # EU legal compliance enforcement
│   └── validation.zig   # Input validation and data checks
│
└── main.zig             # Application entry point
```

```
/tests
├── core_test.zig        # Unit tests for core logic
└── privacy_test.zig     # Tests focused on privacy modules

build.zig                # Build configuration
LICENSE                  # License and legal info
```

---

## 🚀 Usage

To build and run Nythos:

```sh
zig build run
```

> ✅ Ensure **Zig** is installed on your system.
> Check individual source files for additional setup details and usage instructions.

---

## 📝 License

**Dual-licensed** under the **GNU AGPLv3** for community use and the **Veridian Commercial License (VCL 1.0)** for proprietary applications.

See the [LICENSE](LICENSE) file for full details.

---

## ⚖️ Legal Disclaimer

**Veridian Zenith** is a digital label and project organization operated by **Jeremy Matlock**, also known as **Dae Euhwa**.
All works published under this name are the intellectual property of Jeremy Matlock unless otherwise stated.
This project aims to comply with GDPR and other regional privacy frameworks but does not guarantee legal coverage without proper deployment review.

---

© 2025 Veridian Zenith

---
