//
//  PostCellTableViewCell.swift
//  SaltLife
//
//  Created by John Frost on 1/5/16.
//  Copyright © 2016 Pair-A-Dice. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
            }
    
    override func drawRect(rect: CGRect) {
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showcaseImg.clipsToBounds = true
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
