import Network
import Foundation

actor ConnectionStore {
    private var connections: [String: NWConnection] = [:]
    
    func save(connection: NWConnection) -> String {
        let connectionID = UUID().uuidString
        connections[connectionID] = connection
        return connectionID
    }
    
    func remove(id: String) {
        if let _ = connections.removeValue(forKey: id) {
            print("= REMOVED CONNECTION \(id) =")
        } else {
            print("Error removing connection, no such id: \(id)\n")
        }
    }
    
    func get(id: String) -> NWConnection? {
        return connections[id]
    }
    
    func getAll() -> [(String, NWConnection)] {
       return connections.map { ($0.key, $0.value) }
   }
}

let connectionStore = ConnectionStore()
