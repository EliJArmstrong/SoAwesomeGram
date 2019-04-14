//
//  UserVC.swift
//  NotSoAwesomeGram
//
//  Created by Eli Armstrong on 3/4/19.
//  Copyright © 2019 Eli Armstrong. All rights reserved.
//

import UIKit
import Parse

class UserVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post]()
    var imagePicker =  UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        PFUser.current()?.image.getDataInBackground(block: { (imageData, error) in
            if let imageData = imageData{
                self.userImage.image = UIImage(data: imageData)
            } else if let error = error{
                print(error.localizedDescription)
            }
        })
        
        userLbl.text = PFUser.current()?.username
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let query = Post.query()
        // includeKey is to get the actual object not just the address.
        query?.includeKeys(["author", "comments", "comments.author"])
        // added this to place the posts in the right order.
        query?.order(byDescending: "createdAt")
        query?.whereKey("author", equalTo: PFUser.current())
        query?.findObjectsInBackground(block: { (posts, error) in
            if let error = error{
                print(error.localizedDescription)
            } else{
                self.posts = posts as! [Post]
                self.collectionView.reloadData()
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionCell", for: indexPath) as! UserCollectionCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userImage.image = (info[.editedImage] as! UIImage)
        PFUser.current()?.image = Utilities.imageToPFFileObject(image: userImage.image!, imageName: "userImage")
        PFUser.current()?.saveInBackground(block: { (success, error) in
            if let error = error{
                print(error.localizedDescription)
            } else{
                print("userImage updated 😉")
            }
        })
        dismiss(animated: true, completion: nil)
    }
    
}
