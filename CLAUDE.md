Privacy‑Preserving Age‑Verification App & Marketing Landing Page

PurposeThis document is the single source of truth for Claude‑family LLMs (and all contributors) on what to build, how, and in what order to ship a production‑ready iOS app and its landing site. Keep scope tight, bias to shipping.

0  License

This repository is licensed under GPL‑3.0‑or‑later.  All code (Swift, TypeScript, CI) and assets contributed must be compatible.  Contributors agree to release their work under the same license upon merge.

1  Product Summary

Item

Spec

Goal

Let a user prove they are 20 years or older at bars/clubs without disclosing full DOB

v1 App Scope

Local age check by NFC reading of My Number card (Type B) → instant on‑device verdict.ZKP is not required for v1; design hooks for v2.

Landing Page Scope

Single‑page site (Next.js 14 / React 18, static export): hero, problem→solution, GIF demo, early‑access wait‑list (Email → Airtable), JP/EN toggle.

Platforms

Swift 5.9 + SwiftUI iOS 17+ app  /  Next.js static site deployed on Vercel.

Deadline

2025‑07‑31 TestFlight build & landing page live • 2025‑09‑01 App Store submission

Out‑of‑scope (v1)

Android, multi‑ID support, analytics dashboard, ZKP generation

2  System Architecture (v1)

NFC Core – CoreNFC session ➜ APDU ➜ parse DoB (JPKI spec).

Local Age Engine – pure Swift helper; compares DoB ≥ 20 yrs.

UI Flow1️⃣ Launch → Scan screen (animation + progress)2️⃣ Success → big green “OVER 20” badge3️⃣ Failure → big red “UNDER 20” badge

Verifier Mode (optional) – same badge view for staff; no QR yet.

Landing Page Stack – Next.js 14 (App Router) + Tailwind CSS; static export; serverless (Edge) submits email → Airtable.

Hook for v2 – wrap DoB + issuer cert into a ZK proof; maintain clean interfaces.

3  Milestones & Deliverables

Week

Deliverable

Notes

W1

Repo scaffolding → iOS (SwiftPM) + Next.js; CI (GitHub Actions)

Unit‑test target ready • Landing dev env up

W2

Landing MVP → hero copy, email capture, deploy beta.inro.id

Collect wait‑list sign‑ups

W3

CoreNFC read & parse My Number

Mock‑card unit tests

W4

AgeEngine & edge‑case tests (leap day, boundary)

≥100 % branch coverage

W5

SwiftUI screens, L10N (JA/EN)

Apply Figma design tokens • Landing GIF demo polish

W6

Error UX + Accessibility audit

VoiceOver, Dynamic Type

W7

TestFlight Beta 1

Internal QA feedback

W8

Beta 2: Verifier Mode + Crashlytics

Collect crash data

W9

Security review • App Store screenshots • policy text

Confirm PII‑free compliance

W10

App Store submission

Target 2025‑09‑01

4  Coding Standards

iOS App

Swift 5.9+, SwiftUI, async/await only.

Prefer value types & immutability; 唯一の singletonは NFCManager.

Public APIs documented via DocC.

PRs: unit tests ≥ 90 % (Sources/InroCore).

SwiftLint & SwiftFormat enforced.

Localization keys via SwiftGen.

Secrets: none – v1 is 100 % offline.

Landing Page

Next.js 14 + TypeScript.

Styling: Tailwind CSS – no external UI kit.

Form submit via Edge function → Airtable (fallback mailto:).

Lighthouse ≥ 95 (mobile & desktop).

ESLint + Prettier enforced.

General

Commit style: Conventional Commits (feat:, fix:…).

5  Repo Workflow

main branch = release‑ready.

GitHub Issues + Projects (Kanban).

Every PR must:

reference an Issue (Fixes #123),

pass CI (build, test, lint),

be reviewed by human or senior agent.

6  Open Questions (Resolve Before W2)

Final legal wording for age disclaimer on Success screen.

Landing‑page privacy / cookies notice (JP & EN) + GDPR banner.

Payment tier & Vercel billing model for prod hosting.

Confirm JPKI sandbox test cards availability.

7  v2 Roadmap (Preview – out‑of‑scope v1)

ZKP module – Noir circuit, on‑device proof via WASM or Sindri.

QR Verifier – encode ZK proof into compact QR; offline verify.

Android (Kotlin) parity.

Multi‑ID: passport, driver’s license, student ID.

8  How to Engage Claude

When you, Claude, receive a request in this repo:

Follow this charter.

Ask clarifying questions only if essential.

Produce complete, buildable code (Swift or TS).

Always write unit tests.

Output only code or implementation notes as PR comments – no extra prose.

CLAUDE.md v1.2 – 2025‑05‑29All contributors must read and agree before merging code.
