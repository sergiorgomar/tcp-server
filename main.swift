import Foundation
import Network

let port: NWEndpoint.Port = 8080

do {
    let listener = try NWListener(using: .tcp, on: port)
    
    listener.newConnectionHandler = { connection in
        
        connection.start(queue: .global())
        
        // Save connection on memory
        let idConnection = saveConnection(connection: connection)
        
        // Emit message to client
        emitMessage(connection: connection, message: "OK|\(idConnection.split(separator: "-")[0]) WELCOME TO THE SERVER\n")
        
        // Hanle connection
        handleConnection(idConnection: idConnection)
        
        print("= NEW CONNECTION STABLISHED \(idConnection) =")
    }
    
    listener.start(queue: .main)
    print("========= TCP server listening on PORT: \(port)... =======")
    RunLoop.main.run()
    
} catch {
    print("= Error inicializing TCP server: \(error) =")
}
