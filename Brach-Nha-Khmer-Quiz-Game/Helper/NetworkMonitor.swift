//
//  NetworkMonitor.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 10/9/23.
//

//import Foundation
//import Network
//import RealmSwift
//
//class NetworkMonitor {
//    static let shared = NetworkMonitor()
//
//    let monitor = NWPathMonitor()
//    private var status: NWPath.Status = .requiresConnection
//    var isReachable: Bool { status == .satisfied }
//    var isReachableOnCellular: Bool = true
//
//    func startMonitoring() {
//        monitor.pathUpdateHandler = { [weak self] path in
//            self?.status = path.status
//            self?.isReachableOnCellular = path.isExpensive
//
//            if path.status == .satisfied {
//                print("We're connected!")
////                self?.updateDataToServer()
//                
//                // post connected notification
//            } else {
//                print("No connection.")
//                // post disconnected notification
//            }
//            print(path.isExpensive)
//        }
//
//        let queue = DispatchQueue(label: "NetworkMonitor")
//        monitor.start(queue: queue)
//    }
//
//    func stopMonitoring() {
//        monitor.cancel()
//    }
//    
//    func updateDataToServer() {
//        guard let uID = GoogleAuthenticationHelper().getCurrentUser()?.uid else { return }
//        
//        let realm = try! Realm()
//        
//        let realmResult = realm.objects(UserData.self)
//        FirestoreHelper.shared.updateDataToServer(uID: uID, realmResult: realmResult)
//    }
//}
