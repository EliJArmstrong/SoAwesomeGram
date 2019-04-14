//
//  Post.swift
//  NotSoAwesomeGram
//
//  Created by Eli Armstrong on 2/24/19.
//  Copyright © 2019 Eli Armstrong. All rights reserved.
//

import Foundation
import Parse


class Post: PFObject, PFSubclassing{
    
    @NSManaged var media : PFFileObject
    @NSManaged var author: PFUser
    @NSManaged var caption: String
    @NSManaged var likeCount: Int
    @NSManaged var comments: [Comment]
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    func uploadPost(media: UIImageView, caption: String, withCompletion completion: PFBooleanResultBlock?) {
        let post = Post()
        
        post.author = PFUser.current()!
        post.caption = caption
        post.media = Utilities.imageToPFFileObject(image: media.image!, imageName: post.objectId ?? "image")
        post.likeCount = 0
        post.comments = []
        
        post.saveInBackground(block: completion)
    }
    
    
    
}
