//
//  PostCell.swift
//  NotSoAwesomeGram
//
//  Created by Eli Armstrong on 2/24/19.
//  Copyright © 2019 Eli Armstrong. All rights reserved.
//

import UIKit
import AlamofireImage

class PostCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var captionLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var post: Post!{
        didSet{
            usernameLbl.text = post.author.username
            captionLbl.text = post.caption
            let image = post.media
            image.getDataInBackground { (imageData, error) in
                if let error = error{
                    print(error.localizedDescription)
                } else{
                    self.photoView.image = UIImage(data: imageData!)
                }
            }
            
            let userImage = post.author.image
            userImage.getDataInBackground { (imageData, error) in
                if let error = error{
                    print(error.localizedDescription)
                } else{
                    self.userImage.image = UIImage(data: imageData!)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
