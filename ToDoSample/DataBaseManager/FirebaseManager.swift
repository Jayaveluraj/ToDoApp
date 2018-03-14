//
//  FirebaseManager.swift
//  ToDoSample
//
//  Created by DHANDAPANI R on 14/03/18.
//  Copyright © 2018 Jayavelu. All rights reserved.
//

import Foundation
import Firebase
class FireBaseManager{
    
    //MARK : INITIALIZE FIREBASE API
    static func initializeFirebase(){
        FirebaseApp.configure()
    }
    
    //MARK : ANONYMOUS AUTHENTICATION WITH FIREBASE DB
    static func authenticate(completionHandler: @escaping (Bool) -> ()) {
        Auth.auth().signInAnonymously() { (user, error) in
            if error  == nil
            {
                completionHandler(true)
            }else
            {
                completionHandler(false)
            }
        }
    }
}
