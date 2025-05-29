import Foundation
#if canImport(CoreNFC)
import CoreNFC

/// Manages NFC communication with MyNumber cards
@available(iOS 13.0, *)
public final class NFCManager: NSObject {
    public static let shared = NFCManager()
    
    private var session: NFCTagReaderSession?
    private var completion: ((Result<Date, NFCError>) -> Void)?
    
    public enum NFCError: LocalizedError {
        case sessionInvalidated
        case tagNotFound
        case communicationError
        case parsingError
        case unsupportedCard
        
        public var errorDescription: String? {
            switch self {
            case .sessionInvalidated:
                return "NFC session was invalidated"
            case .tagNotFound:
                return "No compatible tag found"
            case .communicationError:
                return "Failed to communicate with card"
            case .parsingError:
                return "Failed to parse card data"
            case .unsupportedCard:
                return "This card type is not supported"
            }
        }
    }
    
    private override init() {
        super.init()
    }
    
    /// Starts an NFC session to read MyNumber card
    /// - Parameter completion: Completion handler with birth date or error
    public func readMyNumberCard(completion: @escaping (Result<Date, NFCError>) -> Void) {
        guard NFCTagReaderSession.readingAvailable else {
            completion(.failure(.sessionInvalidated))
            return
        }
        
        self.completion = completion
        session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        session?.alertMessage = "Hold your MyNumber Card near iPhone"
        session?.begin()
    }
}

// MARK: - NFCTagReaderSessionDelegate
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
                let birthDate = try await readBirthDateFromCard(tag: iso7816Tag)
                
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
    
    private func readBirthDateFromCard(tag: NFCISO7816Tag) async throws -> Date {
        // Select JPKI application
        let jpkiAID = Data([0xD3, 0x92, 0xF0, 0x00, 0x26, 0x01, 0x00, 0x00, 0x00, 0x01])
        let selectCommand = NFCISO7816APDU(
            instructionClass: 0x00,
            instructionCode: 0xA4,
            p1Parameter: 0x04,
            p2Parameter: 0x0C,
            data: jpkiAID,
            expectedResponseLength: -1
        )
        
        _ = try await tag.sendCommand(apdu: selectCommand)
        
        // Read birth date (simplified - actual implementation would need proper APDU commands)
        // This is a placeholder for the actual MyNumber card reading logic
        // In production, this would involve proper certificate reading and parsing
        
        // For now, return a dummy date for testing
        var components = DateComponents()
        components.year = 2000
        components.month = 1
        components.day = 1
        components.timeZone = TimeZone(identifier: "Asia/Tokyo")
        
        guard let date = Calendar.current.date(from: components) else {
            throw NFCError.parsingError
        }
        
        return date
    }
}
#else
// Stub implementation for platforms without CoreNFC
public final class NFCManager {
    public static let shared = NFCManager()
    
    public enum NFCError: LocalizedError {
        case notSupported
        
        public var errorDescription: String? {
            return "NFC is not supported on this platform"
        }
    }
    
    private init() {}
    
    public func readMyNumberCard(completion: @escaping (Result<Date, NFCError>) -> Void) {
        completion(.failure(.notSupported))
    }
}
#endif