import SwiftUI
import InroCore

struct MainView: View {
    @State private var verificationState: VerificationState = .ready
    
    enum VerificationState {
        case ready
        case scanning
        case success
        case failure
        case error(String)
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack(spacing: 40) {
                switch verificationState {
                case .ready:
                    ReadyView(onScanTapped: startScanning)
                case .scanning:
                    ScanningView()
                case .success:
                    SuccessView(onDismiss: resetState)
                case .failure:
                    FailureView(onDismiss: resetState)
                case .error(let message):
                    ErrorView(message: message, onDismiss: resetState)
                }
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private func startScanning() {
        verificationState = .scanning
        
        #if targetEnvironment(simulator)
        // Simulate NFC reading for simulator
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Simulate a person born on 2000-01-01 (over 20)
            verificationState = .success
        }
        #else
        NFCManager.shared.readMyNumberCard { result in
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
        #endif
    }
    
    private func resetState() {
        withAnimation {
            verificationState = .ready
        }
    }
}