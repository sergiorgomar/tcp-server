import Foundation
import Network

// A list of instruccions approved
private let VALID_INSTRUCTIONS = ["EMIT"]

// To decode binary message to UTF8
public func decodeMessage(data: Data) -> String? {
    return String(data: data, encoding: .utf8) ?? nil
}


// Proccess the message decoded, this function call the instruccion and validate errors in message format
public func processMessage(idConnection: String, message: String?) {
    
    guard let connection = connections[idConnection] else {
        print("= Error handling connection, no such id: \(idConnection) =")
        return;
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
    
    guard VALID_INSTRUCTIONS.contains(where: { $0 == instruction }) else {
           let errorMsg = "BAD|<\(instruction)> IS NOT VALID INSTRUCTION\n"
            emitMessage(connection: connection, message: errorMsg)
           return
   }
    
    connections.forEach { (key, connection) in
    
        if(key == idConnection) {
            return
        }
            
        switch connection.state {
            case .ready:
                let okMsg = "OK|\(idConnection.split(separator: "-")[0]) say \(payload)"
                emitMessage(connection: connection, message: okMsg)
            break
            
            default:
            break
        }
    }
       
    
}


// Función auxiliar para enviar datos por la conexión NWConnection
public func emitMessage(connection: NWConnection, message: String) {
    let data = message.data(using: .utf8)!
    connection.send(content: data, completion: .contentProcessed({ error in
        if let error = error {
            print("= An error was occurred trying to emit a message: \(error) =")
        }
    }))
}


