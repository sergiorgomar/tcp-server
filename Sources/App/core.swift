import Foundation
import Network

// A list of instruccions approved
private let VALID_INSTRUCTIONS = ["EMIT"]


// To decode binary message to UTF8
public func decodeMessage(data: Data) -> String? {
    return String(data: data, encoding: .utf8) ?? nil
}

// Process the decoded message, this function calls the instruction and validates message format errors
public func processMessage(idConnection: String, message: String?) async {
    guard let connection = await connectionStore.get(id: idConnection) else {
        print("= Error handling connection, no such id: \(idConnection) =")
        return
    }
    
    guard let message = message else {
        emitMessage(connection: connection, message: "BAD|A MESSAGE IS REQUIRED\n")
        return
    }
    
    let parts = message.split(separator: "|", maxSplits: 1, omittingEmptySubsequences: false)
    
    guard parts.count == 2 else {
        let errorMsg = "BAD|INVALID FORMAT USE: <INSTRUCTION|PAYLOAD>\n"
        emitMessage(connection: connection, message: errorMsg)
        return
    }
    
    let instruction = String(parts[0])
    let payload = String(parts[1])
    
    guard VALID_INSTRUCTIONS.contains(instruction) else {
        let errorMsg = "BAD|<\(instruction)> IS NOT VALID INSTRUCTION\n"
        emitMessage(connection: connection, message: errorMsg)
        return
    }
    
    await connectionStore.getAll().forEach { key, conn in
        if key == idConnection { return }
        
        switch conn.state {
        case .ready:
            let okMsg = "OK|\(idConnection.split(separator: "-")[0]) say \(payload)"
            emitMessage(connection: conn, message: okMsg)
        default:
            break
        }
    }
}

// Helper function to send data over NWConnection
public func emitMessage(connection: NWConnection, message: String) {
    guard let data = message.data(using: .utf8) else { return }
    connection.send(content: data, completion: .contentProcessed({ error in
        if let error = error {
            print("= An error was occurred trying to emit a message: \(error) =")
        }
    }))
}
