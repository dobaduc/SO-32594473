//
//  User.swift
//  BitDate
//
//  Created by Eliot Arntz on 4/1/15.
//  Copyright (c) 2015 bitfountain. All rights reserved.
//

import Foundation

struct User {
    let id: String
    let name: String
    private let pfUser: PFUser
    
    func getPhoto(callback:(UIImage) -> ()) {
        let imageFile = pfUser.objectForKey("picture") as! PFFile
        imageFile.getDataInBackgroundWithBlock({
            data, error in
            if let data = data {
                callback(UIImage(data: data)!)
            }
        })
    }
}

private func pfUserToUser(user: PFUser)->User {
    
    return User(id: user.objectId!, name: user.objectForKey("firstName") as! String, pfUser: user)
}

func currentUser() -> User? {
    if let user = PFUser.currentUser() {
        return pfUserToUser(user)
    }
    return nil
}

func fetchUnviewedUsers(callback: ([User]) -> ()) {
    
    PFUser.query()!
    .whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)
    .findObjectsInBackgroundWithBlock({
        objects, error in
        if let pfUsers = objects as? [PFUser] {
            let users = pfUsers.map({ pfUserToUser($0) })
            callback(users)
        }
        }
    
    )
    
    
}






