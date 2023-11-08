//
//  GoogleAuthenticationHelper.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 10/5/23.
//

import FirebaseCore
import FirebaseAuth
import GoogleSignIn

protocol GoogleAuthenticationHelperDelegate: NSObjectProtocol {
    func signInSuccess(user: User)
    func reAuthenticate(user: User?, error: Error?)
}

class GoogleAuthenticationHelper: NSObject {
    
    weak var delegate: GoogleAuthenticationHelperDelegate?
    
    func signIn(baseVeiw: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: baseVeiw) { result, error in
            guard error == nil else {
                print("Error: ", error?.localizedDescription ?? "Error")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            userdefault.set(idToken, forKey: Constant.userdefault.idToken)
            userdefault.set(user.accessToken.tokenString, forKey: Constant.userdefault.accesstoken)
            
            self.authWithFirebase(credential: credential)

        }
    }
    
    func reAuthenticate() {
        let credential = GoogleAuthProvider.credential(withIDToken: userdefault.string(forKey: Constant.userdefault.idToken) ?? "",
                                                       accessToken: userdefault.string(forKey: Constant.userdefault.accesstoken) ?? "")
                
        Auth.auth().signIn(with: credential) { result,error  in
            if error != nil {
                self.delegate?.reAuthenticate(user: nil, error: error)

                return
            }
            
            if let user = result?.user {
                self.delegate?.reAuthenticate(user: user, error: nil)
            }
        }
    }
    
    
    func signOut(completion: (() -> ())! = nil) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            
            userdefault.set(nil, forKey: Constant.userdefault.accesstoken)
            userdefault.set(nil, forKey: Constant.userdefault.idToken)
            
            DatabaseHelper().resetData()
            FirestoreHelper.shared.stopSync()
            
            completion?()
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    
    func authWithFirebase(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                print("Error: ", error.localizedDescription)
                return
            }
            
            if let user = result?.user {
                self.delegate?.signInSuccess(user: user)
            }
            
        }
        
    }
    
    func getCurrentUser() -> User? {
        let user = Auth.auth().currentUser
        if let user = user {
            return user
        }
        return nil
    }
    
}
