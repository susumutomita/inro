import SwiftUI

struct ScanningView: View {
    @State private var animationAmount = 1.0
    
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.3), lineWidth: 4)
                    .frame(width: 150, height: 150)
                
                Circle()
                    .stroke(Color.blue, lineWidth: 4)
                    .scaleEffect(animationAmount)
                    .opacity(2 - animationAmount)
                    .frame(width: 150, height: 150)
                
                Image(systemName: "wave.3.right")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                    animationAmount = 2
                }
            }
            
            Text(NSLocalizedString("scanning_title", comment: ""))
                .font(.title)
                .fontWeight(.semibold)
            
            Text(NSLocalizedString("scanning_instruction", comment: ""))
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
                .padding(.top)
        }
    }
}