# Inro

Inro` is a state-of-the-art application dedicated to digital identity verification and privacy preservation. Created during the `2024-CircuitBreaker` hackathon, `Inro` seeks to fulfill the societal demand for a secure age verification mechanism in online platforms, adult content access control, among others, without sacrificing user privacy.

## Use Cases

`Inro` facilitates age verification without revealing personal information, making it ideal for bars, rental shops, and similar establishments. The process is simplified into four steps:

### For Users:

- **Scan Your ID**: Currently supports only the MyNumber Card (a government-issued ID card in Japan).
- **Show the QR Code**: Display the QR code generated through the Inro app.

### For Verifiers (e.g., Bar Owners):

- **Scan QR Code**: Use the app to scan the QR code presented.
- **Check Verification Result**: Verify the age without accessing any additional personal information.

## Features

- **Privacy-preserving Age Verification**: Enables age verification without disclosing personal details.
- **Secure and User-friendly Verification Process**: Offers a secure, straightforward interface for quick age verification.
- **Cross-platform Compatibility**: Developed using React Native and TypeScript for seamless operation across iOS and Android devices. (Currently supports iOS only)

## Technology Stack

- **Frontend**: Swift for NFC card Native Modules.
- **Backend**: Utilizes the Sindri API for zero-knowledge proof generation and the Noir proving system for age verification logic.

## How It's Made

Inro prioritizes privacy, security, and simplicity. The backend leverages the Sindri API for zero-knowledge proofs, with Noir for crafting age verification logic, ensuring only necessary age information is verified. The frontend uses modern JavaScript frameworks, including React Native, for a smooth, cross-platform user experience. The integration of Expo's Native Modules for NFC card scanning exemplifies Inro's innovative use of technology.

# Images

## System Overview

<img src=https://github.com/knocks-public/2024-CircuitBreaker/assets/66736869/bad68dd0-5f02-418d-92b7-1ea06867dfb1 width="600">

## Screenshots

<img src=https://github.com/knocks-public/2024-CircuitBreaker/assets/11481781/67752380-cd64-4fb6-a245-cb4747d97e35 width=19%>
<img src=https://github.com/knocks-public/2024-CircuitBreaker/assets/11481781/239a4a0e-1ff7-469b-b9a0-7201e644f69b width=19%>
<img src=https://github.com/knocks-public/2024-CircuitBreaker/assets/11481781/091adb57-bb35-410d-96ad-0ed38ece1c24 width=19%>
<img src=https://github.com/knocks-public/2024-CircuitBreaker/assets/11481781/74e4c3f9-614f-4b37-a201-5d6db936f1ab width=19%>
<img src=https://github.com/knocks-public/2024-CircuitBreaker/assets/11481781/98d1e650-281d-42f3-aae7-ea089432f236 width=19%>
