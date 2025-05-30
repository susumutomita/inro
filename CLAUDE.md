# CLAUDE.md – Development Charter for **Inro**

*Privacy‑Preserving Age‑Verification App & Marketing Landing Page*

> **Purpose**
> This document is the **single source of truth** for Claude‑family LLMs (and all contributors) on **what to build, how, and in what order** to ship a production‑ready iOS app *and* its landing site. Keep scope tight, bias to shipping.

---

## 0  License

This repository is licensed under **GPL‑3.0‑or‑later**.  All code (Swift, TypeScript, CI) and assets contributed must be compatible.  Contributors agree to release their work under the same license upon merge.

---

## 1  Product Summary

| Item                   | Spec                                                                                                                                                    |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Goal**               | Let a user prove they are **20 years or older** at bars/clubs **without disclosing full DOB**                                                           |
| **v1 App Scope**       | *Local* age check by **NFC** reading of My Number card (Type B) → instant on‑device verdict.<br>ZKP is **not** required for v1; design hooks for v2.    |
| **Landing Page Scope** | Single‑page site (**Next.js 14 / React 18**, static export): hero, problem→solution, GIF demo, early‑access wait‑list (Email → Airtable), JP/EN toggle. |
| **Platforms**          | **Swift 5.9 + SwiftUI** iOS 17+ app  /  Next.js static site deployed on **Vercel**.                                                                     |
| **Deadline**           | **2025‑07‑31** TestFlight build **&** landing page live • **2025‑09‑01** App Store submission                                                           |
| **Out‑of‑scope (v1)**  | Android, multi‑ID support, analytics dashboard, ZKP generation                                                                                          |

---

## 2  System Architecture (v1)

1. **NFC Core** – `CoreNFC` session ➜ APDU ➜ parse DoB (JPKI spec).
2. **Local Age Engine** – pure Swift helper; compares DoB ≥ 20 yrs.
3. **UI Flow**
   1️⃣ Launch → *Scan* screen (animation + progress)
   2️⃣ Success → big green **“OVER 20”** badge
   3️⃣ Failure → big red **“UNDER 20”** badge
4. **Verifier Mode** *(optional)* – same badge view for staff; no QR yet.
5. **Landing Page Stack** – Next.js 14 (App Router) + Tailwind CSS; static export; serverless (Edge) submits email → Airtable.

> **Hook for v2** – wrap DoB + issuer cert into a ZK proof; maintain clean interfaces.

---

## 3  Milestones & Deliverables

| Week    | Deliverable                                                         | Notes                                               |
| ------- | ------------------------------------------------------------------- | --------------------------------------------------- |
| **W1**  | Repo scaffolding → iOS (SwiftPM) + Next.js; CI (GitHub Actions)     | Unit‑test target ready • Landing dev env up         |
| **W2**  | **Landing MVP** → hero copy, email capture, deploy **beta.inro.id** | Collect wait‑list sign‑ups                          |
| **W3**  | CoreNFC read & parse My Number                                      | Mock‑card unit tests                                |
| **W4**  | AgeEngine & edge‑case tests (leap day, boundary)                    | ≥100 % branch coverage                              |
| **W5**  | SwiftUI screens, L10N (JA/EN)                                       | Apply Figma design tokens • Landing GIF demo polish |
| **W6**  | Error UX + Accessibility audit                                      | VoiceOver, Dynamic Type                             |
| **W7**  | **TestFlight Beta 1**                                               | Internal QA feedback                                |
| **W8**  | Beta 2: Verifier Mode + Crashlytics                                 | Collect crash data                                  |
| **W9**  | Security review • App Store screenshots • policy text               | Confirm **PII‑free** compliance                     |
| **W10** | **App Store submission**                                            | Target **2025‑09‑01**                               |

---

## 4  Coding Standards

### iOS App

1. **Swift 5.9+, SwiftUI, async/await** only.
2. Prefer value types & immutability; *唯一の* singletonは `NFCManager`.
3. Public APIs documented via **DocC**.
4. PRs: unit tests ≥ 90 % (Sources/InroCore).
5. **SwiftLint** & **SwiftFormat** enforced.
6. Localization keys via **SwiftGen**.
7. Secrets: none – v1 is 100 % offline.

### Landing Page

1. **Next.js 14 + TypeScript**.
2. Styling: **Tailwind CSS** – no external UI kit.
3. Form submit via Edge function → Airtable (fallback `mailto:`).
4. **Lighthouse ≥ 95** (mobile & desktop).
5. ESLint + Prettier enforced.

### General

* Commit style: **Conventional Commits** (`feat:`, `fix:`…).

---

## 5  Repo Workflow

1. **main** branch = release‑ready.
2. GitHub Issues + Projects (Kanban).
3. Every PR must:

   * reference an Issue (`Fixes #123`),
   * pass CI (`build`, `test`, `lint`),
   * be reviewed by human or senior agent.

---

## 6  Open Questions (Resolve Before W2)

* Final legal wording for **age disclaimer** on Success screen.
* Landing‑page **privacy / cookies notice** (JP & EN) + GDPR banner.
* Payment tier & **Vercel billing** model for prod hosting.
* Confirm **JPKI sandbox** test cards availability.

---

## 7  v2 Roadmap (Preview – out‑of‑scope v1)

* **ZKP module** – Noir circuit, on‑device proof via WASM or Sindri.
* **QR Verifier** – encode ZK proof into compact QR; offline verify.
* **Android (Kotlin)** parity.
* Multi‑ID: passport, driver’s license, student ID.

---

## 8  How to Engage Claude

> **When you, Claude, receive a request in this repo:**
>
> 1. Follow this charter.
> 2. Ask clarifying questions *only* if essential.
> 3. Produce **complete, buildable code** (Swift or TS).
> 4. Always write unit tests.
> 5. Output only code or implementation notes as PR comments – **no extra prose**.

---

## Inro Repository – Directory Structure (v1.0)

> **Purpose**  This document explains *why* each top‑level folder exists and *what* goes inside, so Claude／human contributors can navigate and add code without breaking the architecture.

```text
inro/
├─ ios/                     # iOS app (Swift / SwiftUI)
│  ├─ Package.swift         # SwiftPM root – defines modular targets
│  ├─ InroCore/             # Business logic: NFC, AgeEngine, utilities
│  │   └─ Sources/
│  ├─ InroUI/               # SwiftUI views & DesignSystem
│  ├─ InroApp/              # @main entry + Scene/Delegate
│  └─ Inro.xcodeproj/       # Single Xcode project referencing SwiftPM targets
│
├─ zk/                      # Zero‑Knowledge proof stack (out‑of‑scope v1)
│  ├─ circuits/             # Noir / Circom files (*.ncl, *.circom)
│  ├─ src/                  # Rust → WASM prover / verifier libs
│  ├─ Cargo.toml            # Rust workspace root
│  ├─ package.json          # JS glue for wasm‑pack (optional)
│  └─ README.md             # Build & test instructions
│
├─ landing/                 # Marketing site (Next.js 14)
│  ├─ app/                  # App Router pages & layouts
│  ├─ public/               # Static assets (images, og images)
│  ├─ tailwind.config.ts
│  └─ next.config.mjs
│
├─ scripts/                 # Cross‑toolchain automation
│  ├─ build_ios.sh          # CI helper → xcodebuild
│  ├─ build_wasm.sh         # wasm‑pack + cargo test
│  └─ ci_post_process.ts
│
├─ docs/                    # Architecture diagrams, API specs, research
│  ├─ architecture.md       # Sequence + data flow diagrams
│  └─ api.md                # (v2) REST / FFI interface spec
│
├─ .github/                 # GitHub Actions & configs
│  ├─ workflows/            # ios.yml / zk.yml / web.yml
│  └─ dependabot.yml
│
├─ CLAUDE.md                # Development charter (master rules)
├─ DIRECTORY_STRUCTURE.md   # ← you are here
└─ README.md                # Quick start & high‑level overview
```

## Folder Intent & Rules

| Folder     | Must contain                                               | Must *NOT* contain   |
| ---------- | ---------------------------------------------------------- | -------------------- |
| `ios/`     | Only Swift / SwiftUI sources, Xcode artifacts, `.xcassets` | Rust, JS, web assets |
| `zk/`      | Noir circuits, Rust prover, WASM builds                    | iOS code, UI assets  |
| `landing/` | Next.js (TS/JS, Tailwind), marketing images                | Swift, Rust          |
| `scripts/` | Build / deploy helpers (bash, TS)                          | Product code         |
| `docs/`    | Markdown docs, PNG/SVG diagrams                            | Compiled binaries    |

## Build‑Matrix Mapping

| CI Job      | Path watched | Artifact                       |
| ----------- | ------------ | ------------------------------ |
| **ios.yml** | `ios/**`     | `.ipa` + XCTest report         |
| **zk.yml**  | `zk/**`      | WASM package + unit tests      |
| **web.yml** | `landing/**` | Static export → Vercel preview |

## Contribution Checklist

1. **Place files in the right folder** per table above.
2. **Update CLAUDE.md milestones** if changing build graph.
3. **Run local linters** (`swiftlint`, `eslint`).
4. **Open a PR** with Conventional Commit title.
