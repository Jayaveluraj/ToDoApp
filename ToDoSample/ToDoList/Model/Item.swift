//
//  Item.swift
//  ToDoSample
//
//  Created by DHANDAPANI R on 09/03/18.
//  Copyright © 2018 Jayavelu. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Item {
    var ref : DatabaseReference?
    var title : String?
    var date : String?
    init(snapshot: DataSnapshot) {
        self.ref = snapshot.ref
        var data  = snapshot.value as! Dictionary<String,String>
        self.title = data["title"]
        self.date = data["date"]
    }
}
