import SwiftUI
import InroCore

public struct ScanView: View {
    @State private var verificationState: VerificationState = .ready
    
    public enum VerificationState {
        case ready
        case scanning
        case success
        case failure
        case error(String)
    }
    
    public init() {}
    
    public var body: some View {
        ZStack {
            backgroundGradient
            
            VStack(spacing: DesignSystem.Spacing.xxLarge) {
                switch verificationState {
                case .ready:
                    ReadyContent(onScanTapped: startScanning)
                case .scanning:
                    ScanningContent()
                case .success:
                    SuccessContent(onDismiss: resetState)
                case .failure:
                    FailureContent(onDismiss: resetState)
                case .error(let message):
                    ErrorContent(message: message, onDismiss: resetState)
                }
            }
            .padding()
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                DesignSystem.Colors.backgroundGradientStart,
                DesignSystem.Colors.backgroundGradientEnd
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private func startScanning() {
        withAnimation(DesignSystem.Animation.standard) {
            verificationState = .scanning
        }
        
        #if targetEnvironment(simulator)
        // Simulate NFC reading for simulator
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Simulate a person born on 2000-01-01 (over 20)
            let birthDate = DateComponents(
                calendar: .current,
                year: 2000,
                month: 1,
                day: 1
            ).date!
            
            withAnimation(DesignSystem.Animation.standard) {
                if AgeEngine.isOverMinimumAge(birthDate: birthDate) {
                    verificationState = .success
                } else {
                    verificationState = .failure
                }
            }
        }
        #else
        NFCManager.shared.readMyNumberCard { result in
            withAnimation(DesignSystem.Animation.standard) {
                switch result {
                case .success(let birthDate):
                    if AgeEngine.isOverMinimumAge(birthDate: birthDate) {
                        verificationState = .success
                    } else {
                        verificationState = .failure
                    }
                case .failure(let error):
                    verificationState = .error(error.localizedDescription)
                }
            }
        }
        #endif
    }
    
    private func resetState() {
        withAnimation(DesignSystem.Animation.standard) {
            verificationState = .ready
        }
    }
}

// MARK: - Content Views
private struct ReadyContent: View {
    let onScanTapped: () -> Void
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            Image(systemName: "person.text.rectangle")
                .font(.system(size: 100))
                .foregroundColor(DesignSystem.Colors.primaryBlue)
                .symbolEffect(.pulse)
            
            Text("age_verification_title")
                .font(DesignSystem.Typography.largeTitle)
            
            Text("scan_instruction")
                .font(DesignSystem.Typography.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button(action: onScanTapped) {
                Label("scan_card_button", systemImage: "wave.3.right")
            }
            .buttonStyle(DesignSystem.ButtonStyle())
            .padding(.top, DesignSystem.Spacing.large)
        }
    }
}

private struct ScanningContent: View {
    @State private var animationAmount = 1.0
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            ZStack {
                Circle()
                    .stroke(DesignSystem.Colors.primaryBlue.opacity(0.3), lineWidth: 4)
                    .frame(width: 150, height: 150)
                
                Circle()
                    .stroke(DesignSystem.Colors.primaryBlue, lineWidth: 4)
                    .scaleEffect(animationAmount)
                    .opacity(2 - animationAmount)
                    .frame(width: 150, height: 150)
                
                Image(systemName: "wave.3.right")
                    .font(.system(size: 60))
                    .foregroundColor(DesignSystem.Colors.primaryBlue)
            }
            .onAppear {
                withAnimation(DesignSystem.Animation.pulse) {
                    animationAmount = 2
                }
            }
            
            Text("scanning_title")
                .font(DesignSystem.Typography.title)
            
            Text("scanning_instruction")
                .font(DesignSystem.Typography.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
                .padding(.top)
        }
    }
}

private struct SuccessContent: View {
    let onDismiss: () -> Void
    @State private var showCheckmark = false
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xxLarge) {
            ZStack {
                Circle()
                    .fill(DesignSystem.Colors.successGreen)
                    .frame(width: 200, height: 200)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 100, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(showCheckmark ? 1 : 0.5)
                    .opacity(showCheckmark ? 1 : 0)
            }
            .onAppear {
                withAnimation(DesignSystem.Animation.spring) {
                    showCheckmark = true
                }
            }
            
            Text("over_20_badge")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(DesignSystem.Colors.successGreen)
            
            Text("verification_success")
                .font(DesignSystem.Typography.body)
                .foregroundColor(.secondary)
            
            Button("done_button", action: onDismiss)
                .buttonStyle(DesignSystem.ButtonStyle(backgroundColor: DesignSystem.Colors.successGreen))
                .padding(.top, DesignSystem.Spacing.large)
        }
    }
}

private struct FailureContent: View {
    let onDismiss: () -> Void
    @State private var showX = false
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xxLarge) {
            ZStack {
                Circle()
                    .fill(DesignSystem.Colors.failureRed)
                    .frame(width: 200, height: 200)
                
                Image(systemName: "xmark")
                    .font(.system(size: 100, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(showX ? 1 : 0.5)
                    .opacity(showX ? 1 : 0)
            }
            .onAppear {
                withAnimation(DesignSystem.Animation.spring) {
                    showX = true
                }
            }
            
            Text("under_20_badge")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(DesignSystem.Colors.failureRed)
            
            Text("age_requirement_not_met")
                .font(DesignSystem.Typography.body)
                .foregroundColor(.secondary)
            
            Button("ok_button", action: onDismiss)
                .buttonStyle(DesignSystem.ButtonStyle(backgroundColor: DesignSystem.Colors.failureRed))
                .padding(.top, DesignSystem.Spacing.large)
        }
    }
}

private struct ErrorContent: View {
    let message: String
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 80))
                .foregroundColor(DesignSystem.Colors.warningOrange)
            
            Text("error_title")
                .font(DesignSystem.Typography.largeTitle)
            
            Text(message)
                .font(DesignSystem.Typography.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("try_again_button", action: onDismiss)
                .buttonStyle(DesignSystem.ButtonStyle(backgroundColor: DesignSystem.Colors.warningOrange))
                .padding(.top, DesignSystem.Spacing.large)
        }
    }
}