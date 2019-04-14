//
//  CommentCell.swift
//  NotSoAwesomeGram
//
//  Created by Eli Armstrong on 3/3/19.
//  Copyright © 2019 Eli Armstrong. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var comment: Comment!{
        didSet{
            userLbl.text = comment.author.username ?? ""
            commentLbl.text = comment.text
            let image = comment.author.image
            image.getDataInBackground { (imageData, error) in
                if let imageData = imageData{
                    self.userImage.image = UIImage(data: imageData)
                } else if let error = error{
                    print(error.localizedDescription)
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
