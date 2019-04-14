//
//  FeedVC.swift
//  NotSoAwesomeGram
//
//  Created by Eli Armstrong on 2/24/19.
//  Copyright © 2019 Eli Armstrong. All rights reserved.
//

import UIKit
import Parse
import MessageInputBar

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var selectedPost: Post!
    var showsCommentBar = false
    
    let commentBar = MessageInputBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        let center = NotificationCenter.default
        
        
        // (observer) self: the VC with the fuction to be called.
        // selector: The function to be called.
        // name: The NSNotification.name to be looking (listening  for)
        // object: The thing that sent the notifiation. (Most of the time you just want it to be nil.
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillBeHidden(note: Notification){
        dismissKeyBoard()
    }
    
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool{
        return showsCommentBar
    }
    
    @IBAction func onLogoutBtn(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = main.instantiateViewController(withIdentifier: "LoginVC")
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = loginVC
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let query = Post.query()
        // includeKey is to get the actual object not just the address.
        query?.includeKeys(["author", "comments", "comments.author"])
        // added this to place the posts in the right order.
        query?.order(byDescending: "createdAt")
        query?.limit = 20
        query?.findObjectsInBackground(block: { (posts, error) in
            if let error = error{
                print(error.localizedDescription)
            } else{
                self.posts = posts as! [Post]
                self.tableView.reloadData()
            }
        })
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        let comment = Comment()
        comment.postComment(text: commentBar.inputTextView.text, post: selectedPost) { (success, error) in
            if(success){
                print("Comment saved 😁")
                self.tableView.reloadData()
            } else{
                print("Error saving comment 😭🙄")
            }
        }
        
        dismissKeyBoard()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = post.comments

        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        let comments = post.comments
        
        if(indexPath.row == 0){
            // Selling PFSubclassing: Hat analogy
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
            cell.post = post
            return cell // Having muilple return statements is a no-no but xCode yells at us if we don't in this case sooo, ya.
        } else if(indexPath.row <= comments.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            cell.comment = comments[indexPath.row - 1]
            return cell // Having muilple return statements is a no-no but xCode yells at us if we don't in this case sooo, ya.
        } else{
           return tableView.dequeueReusableCell(withIdentifier: "AddCommentCell", for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        selectedPost = posts[indexPath.section] // Make sure this is a section not row.
        
        if(indexPath.row == selectedPost.comments.count + 1){
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
        } else{
            dismissKeyBoard()
        }
        
    }
    
    func dismissKeyBoard(){
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }

}
