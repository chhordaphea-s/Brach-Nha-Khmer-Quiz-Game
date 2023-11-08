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
        
        if GoogleAuthenticationHelper().getCurrentUser() == nil { return }
        
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
                
                addDataToServer(uID: uID, data: data)

                break
            case .update(_, _, _, _):
                // Handle updates, deletions, and insertions
                guard let uID = realmResults.first?.userID else { return }

                updateDataToServer(uID: uID, realmResult: realmResults)
                break
            case .error(let error):
                // Handle errors
                print("Realm error: \(error.localizedDescription)")
                break
            }
        }
    }
    
    func addDataToServer(uID: String,  data: [String : Any]) {
        let docRef = self.db.collection(Constant.server.collectionID).document(uID)
        docRef.setData(["data" : data]) { error in
            if let error = error {
                print("Error Adding Firestore: \(error.localizedDescription)")
            } else {
                print("Firestore Added successfully")

            }
        }
    }
    
    func updateDataToServer(uID: String, realmResult: Results<UserData>) {
        let dataToSync = realmResult[0].toFirestoreDictionary()

        let docRef = self.db.collection(Constant.server.collectionID).document(uID)
        docRef.setData(["data" : dataToSync]) { error in
            if let error = error {
                print("Error updating Firestore: \(error.localizedDescription)")
            } else {
                print("Firestore updated successfully")
            }
        }
        
    }

    func stopSync() {
        realmNotificationToken?.invalidate()
        realmNotificationToken = nil
    }
    
    func fetchData(userID: String, completion: ((_ error: Error?) -> ())! = nil) {
        let docRef = db.collection(Constant.server.collectionID).document(userID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                DatabaseHelper().resetData()
                let realmData = UserData.fromFirestoreDictionary(data!["data"] as! [String : Any])
                
                DatabaseHelper().writeTheHoldData(data: realmData)
                self.startSync()
                print("Database: ", DatabaseHelper().fetchData())
                
                completion?(error)
            } else {
                if DatabaseHelper().isEmpty() {
                    
                    DatabaseHelper().loadData()
                    self.startSync()

                } else {
                    let realmResult = DatabaseHelper().fetchData()
                    self.addDataToServer(uID: userID, data: realmResult.toFirestoreDictionary())
                    self.startSync()
                }
                completion?(error)
                
                print("Firestore document does not exist or there was an error: \(error?.localizedDescription ?? "Unknown error")")
                
            }
        }
        
    }

}
