//
//  PostCellTableViewCell.swift
//  SaltLife
//
//  Created by John Frost on 1/5/16.
//  Copyright © 2016 Pair-A-Dice. All rights reserved.
//

import UIKit
import Alamofire
import Firebase


class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    
    private var _post: Post?
    
    var post: Post? {
        return _post
    }
    
    var request: Request?
    var likeRef: Firebase!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.userInteractionEnabled = true
    }
    
    override func drawRect(rect: CGRect) {
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        showcaseImg.clipsToBounds = true
    }

    func configureCell(post: Post, img: UIImage?) {
        self.showcaseImg.image = nil
        self._post = post
        self.likeRef = REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        self.descriptionText.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"
        if post.imageUrl != nil {
            if img != nil {
                showcaseImg.image = img
            }else{
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    
                    if err == nil{
                        let img = UIImage(data: data!)!
                        self.showcaseImg.image = img
                        Feed_VC.imageCache.setObject(img, forKey: self.post!.imageUrl!)
                    }else {
                        print(err.debugDescription)
                    }
                })
            }
        }else {
            self.showcaseImg.hidden = true
        }
        
        print("LIKE_REF = \(likeRef)")
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "heart-empty")
            }else {
                self.likeImage.image = UIImage(named: "heart-full")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            //If I haven't like this, then like it, otherwise un-like it
            if let _ = snapshot.value as? NSNull {
                self.likeRef.setValue(true)
                self.likeImage.image = UIImage(named: "heart-full")
                self.post!.adjustLikes(true)
                
            } else {
                self.likeRef.removeValue()
                self.likeImage.image = UIImage(named: "heart-empty")
                self.post!.adjustLikes(false)
            }
            
            self.likesLbl.text = "\(self.post!.likes)"
        })
    }

}
