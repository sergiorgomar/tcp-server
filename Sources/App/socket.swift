import Network
import Foundation

public func saveConnection(connection: NWConnection) async -> String {
    return await connectionStore.save(connection: connection)
}

public func removeConnection(idConnection: String) async {
    await connectionStore.remove(id: idConnection)
}

public func handleConnection(idConnection: String) async {
    
    guard let connection = await connectionStore.get(id: idConnection) else {
        print("= Error handling connection, no such id: \(idConnection) =")
        return
    }
    
    connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { data, context, isComplete, error in
        
       
        if let data = data, !data.isEmpty {
            let message = decodeMessage(data: data)
            Task{
                await processMessage(idConnection: idConnection, message: message)
            }
        }
        
        if isComplete {
            Task {
                await removeConnection(idConnection: idConnection)
            }
            return
        }
        
        if let error = error {
            print("= Error establishing connection: \(error) =")
            Task {
                await removeConnection(idConnection: idConnection)
            }
            connection.cancel()
            return
        }
            
       
        Task {
            await handleConnection(idConnection: idConnection)
        }
    }
}


