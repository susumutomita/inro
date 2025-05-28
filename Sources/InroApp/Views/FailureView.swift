import SwiftUI

struct FailureView: View {
    let onDismiss: () -> Void
    @State private var showX = false
    
    var body: some View {
        VStack(spacing: 40) {
            ZStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 200, height: 200)
                
                Image(systemName: "xmark")
                    .font(.system(size: 100, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(showX ? 1 : 0.5)
                    .opacity(showX ? 1 : 0)
            }
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    showX = true
                }
            }
            
            Text(NSLocalizedString("under_20_badge", comment: ""))
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.red)
            
            Text(NSLocalizedString("age_requirement_not_met", comment: ""))
                .font(.title3)
                .foregroundColor(.secondary)
            
            Button(action: onDismiss) {
                Text(NSLocalizedString("ok_button", comment: ""))
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
        }
    }
}