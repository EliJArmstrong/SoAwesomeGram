//
//  Comment.swift
//  NotSoAwesomeGram
//
//  Created by Eli Armstrong on 3/3/19.
//  Copyright © 2019 Eli Armstrong. All rights reserved.
//

import Foundation
import Parse


class Comment: PFObject, PFSubclassing{
    
    static func parseClassName() -> String {
        return "Comments"
    }
    
    @NSManaged var text: String
    @NSManaged var post: Post
    @NSManaged var author: PFUser
    
    func postComment(text: String, post: Post, withCompletion completion: PFBooleanResultBlock?){
        self.text = text
        self.post = post
        self.post.comments.append(self)
        self.author = PFUser.current()!
        
        self.post.saveInBackground(block: completion)
    }
    
    
}
