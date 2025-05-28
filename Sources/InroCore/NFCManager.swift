import Foundation
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
    
    private func selectJPKIApplication(tag: NFCISO7816Tag) async throws {
        // JPKI Application ID
        let jpkiAID = Data([0xD3, 0x92, 0xF0, 0x00, 0x26, 0x01, 0x00, 0x00, 0x00, 0x01])
        let selectCommand = NFCISO7816APDU(
            instructionClass: 0x00,
            instructionCode: 0xA4,
            p1Parameter: 0x04,
            p2Parameter: 0x0C,
            data: jpkiAID,
            expectedResponseLength: -1
        )
        
        let (_, _, error) = try await tag.sendCommand(apdu: selectCommand)
        if let error = error {
            throw error
        }
    }
    
    private func readBirthDate(tag: NFCISO7816Tag) async throws -> Date {
        // Read birth date from MyNumber card
        // This is a simplified implementation
        let readCommand = NFCISO7816APDU(
            instructionClass: 0x00,
            instructionCode: 0xB0,
            p1Parameter: 0x00,
            p2Parameter: 0x00,
            data: Data(),
            expectedResponseLength: 256
        )
        
        let (responseData, sw1, sw2, error) = try await tag.sendCommand(apdu: readCommand)
        
        if let error = error {
            throw error
        }
        
        guard sw1 == 0x90 && sw2 == 0x00 else {
            throw NFCError.communicationError
        }
        
        // Parse birth date from response
        // Format: YYYYMMDD
        guard responseData.count >= 8,
              let birthDateString = String(data: responseData.prefix(8), encoding: .utf8),
              let year = Int(birthDateString.prefix(4)),
              let month = Int(birthDateString.dropFirst(4).prefix(2)),
              let day = Int(birthDateString.dropFirst(6).prefix(2)) else {
            throw NFCError.parsingError
        }
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.timeZone = TimeZone(identifier: "Asia/Tokyo")
        
        guard let date = Calendar.current.date(from: components) else {
            throw NFCError.parsingError
        }
        
        return date
    }
}