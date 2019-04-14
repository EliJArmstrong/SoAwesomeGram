//
//  UserCollectionCell.swift
//  NotSoAwesomeGram
//
//  Created by Eli Armstrong on 3/4/19.
//  Copyright © 2019 Eli Armstrong. All rights reserved.
//

import UIKit

class UserCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    var post: Post!{
        didSet{
            post.media.getDataInBackground { (imageData, error) in
                if let error = error{
                    print(error.localizedDescription)
                } else{
                    self.image.image = UIImage(data: imageData!)
                }
            }
        }
    }
}
