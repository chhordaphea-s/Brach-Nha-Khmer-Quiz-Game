//
//  FirestoreHelper.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 10/5/23.
//

import RealmSwift
import FirebaseCore
import FirebaseFirestore

class FirestoreHelper {
    
    static let shared = FirestoreHelper() // Singleton instance
    
    private var realmNotificationToken: NotificationToken?
    private var db: Firestore!

    private init() {
        db = Firestore.firestore()
    }

    func startSync() {
        // Initialize Realm
        let realm = try! Realm()
        let realmResults = realm.objects(UserData.self)
        
        print("Dictionary Data: ", realmResults.map {$0.toFirestoreDictionary()})
        print("RealmData: ", realmResults[0])

        // Observe changes in Realm and sync to Firestore`
        realmNotificationToken = realmResults.observe { [weak self] changes in
            guard let self = self else { return }

            switch changes {
            case .initial:
                guard let uID = realmResults.first?.userID else { return }
                let data = realmResults[0].toFirestoreDictionary()
                
                let docRef = self.db.collection(Constant.server.collectionID).document(uID)
                docRef.setData(["data" : data]) { error in
                    if let error = error {
                        print("Error Adding Firestore: \(error.localizedDescription)")
                    } else {
                        print("Firestore Added successfully")

                    }
                }

                break
            case .update(_, _, _, _):
                // Handle updates, deletions, and insertions
                guard let uID = realmResults.first?.userID else { return }
                let dataToSync = realmResults[0].toFirestoreDictionary()

                // Update the data in Firestore
                let docRef = self.db.collection(Constant.server.collectionID).document(uID)
                docRef.setData(["data" : dataToSync]) { error in
                    if let error = error {
                        print("Error updating Firestore: \(error.localizedDescription)")
                    } else {
                        print("Firestore updated successfully")
                    }
                }

                break
            case .error(let error):
                // Handle errors
                print("Realm error: \(error.localizedDescription)")
                break
            }
        }
    }

    func stopSync() {
        realmNotificationToken?.invalidate()
        realmNotificationToken = nil
    }
    
//    func fetchData(userID: String) {
//        let dotRef = try db.collection(Constant.server.collectionID).document(userID)
//        dotRef.getDocument { document, error in
//            if error != nil {
//                print("Error Fetching Data: ", error?.localizedDescription)
//                return
//            }
//            
//            print("document: ", document?.data())
//        }
//    }
    
    
    func fetchData(userID: String, completion: ((_ error: Error?) -> ())! = nil) {
        let docRef = db.collection(Constant.server.collectionID).document(userID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()

                let realmData = UserData.fromFirestoreDictionary(data!["data"] as! [String : Any])

                DatabaseHelper().writeTheHoldData(data: realmData)
                print("Database: ", DatabaseHelper().fetchData())
                
                completion?(error)
            } else {
                DatabaseHelper().loadData()
                self.startSync()
                
                completion?(error)

                print("Firestore document does not exist or there was an error: \(error?.localizedDescription ?? "Unknown error")")
                
            }
        }
        
    }
    
}
