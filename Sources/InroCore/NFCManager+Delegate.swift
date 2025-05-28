import Foundation
import CoreNFC

@available(iOS 13.0, *)
extension NFCManager: NFCTagReaderSessionDelegate {
    public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        // Session is active
    }
    
    public func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError,
           readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead &&
           readerError.code != .readerSessionInvalidationErrorUserCanceled {
            completion?(.failure(.sessionInvalidated))
        }
        
        self.session = nil
        self.completion = nil
    }
    
    public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "No tag found")
            completion?(.failure(.tagNotFound))
            return
        }
        
        guard case .iso7816(let iso7816Tag) = tag else {
            session.invalidate(errorMessage: "Incompatible tag type")
            completion?(.failure(.unsupportedCard))
            return
        }
        
        Task {
            do {
                try await session.connect(to: tag)
                try await selectJPKIApplication(tag: iso7816Tag)
                let birthDate = try await readBirthDate(tag: iso7816Tag)
                
                await MainActor.run {
                    session.invalidate()
                    completion?(.success(birthDate))
                }
            } catch {
                await MainActor.run {
                    session.invalidate(errorMessage: "Failed to read card")
                    completion?(.failure(.communicationError))
                }
            }
        }
    }
}