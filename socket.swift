import Network
import Foundation

var connections: [String: NWConnection] = [:]

// To save a connection in memory
public func saveConnection(connection: NWConnection) -> String {
    let connectionID = UUID().uuidString
    connections[connectionID] = connection
    return connectionID;
}

// To delete a connection from memory
public func removeConnection(idConnection: String) {
    guard let _ = connections.removeValue(forKey: idConnection) else {
        print("Error removing connection, no such id: \(idConnection)\n")
        return
    }
    print("= REMOVED CONNECTION \(idConnection) =")
}


// To handle the buffer data of the connection
public func handleConnection(idConnection: String) {
    
    guard let connection = connections[idConnection] else {
        print("= Error handling connection, no such id: \(idConnection) =")
        return;
    }
        
    connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { data, context, isComplete, error in
        
        if let data = data, !data.isEmpty {
            let message = decodeMessage(data: data)
            processMessage(idConnection: idConnection, message: message)
        }
        
        if isComplete {
            removeConnection(idConnection: idConnection)
            return
        }
        
        if let error = error {
            print("= Error stablishing connection: \(error) =")
            removeConnection(idConnection: idConnection)
            connection.cancel()
            return
        }
        
        handleConnection(idConnection: idConnection)
    }
}


