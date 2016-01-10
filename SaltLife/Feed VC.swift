//
//  Feed VC.swift
//  SaltLife
//
//  Created by John Frost on 1/5/16.
//  Copyright © 2016 Pair-A-Dice. All rights reserved.
//

import UIKit
import Firebase
import Alamofire


class Feed_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    var posts = [Post]()
    var imageSelected = false
    static var imageCache = NSCache()
    var imagePicker: UIImagePickerController!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 366
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    //print("Snap: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
            //print(snapshot.value)
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell{
            cell.request?.cancel()
            var img: UIImage?
            if let url = post.imageUrl {
                img = Feed_VC.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post, img: img)
            return cell
            
        }else {
            return PostCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        if post.imageUrl == nil {
            return 155
        }else {
            return tableView.estimatedRowHeight
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        var image: UIImage
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            image = possibleImage
            
            }else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
                image = possibleImage
                
            }else{
                return
            }
        
        imageSelectorImage.image = image
        imageSelected = true
        
    }
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func makePost(sender: AnyObject) {
        if let txt = postField.text where txt != "" {
            if let img = imageSelectorImage.image where imageSelected == true {
                let urlStr = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlStr)!
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                let keyData = "39EFMQRX83f78a5cb51ab3277212368781df4b28".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                Alamofire.upload(.POST, url, multipartFormData: { MultipartFormData in
                    
                    //This is the body of the upload request.
                    MultipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                    MultipartFormData.appendBodyPart(data: keyData, name: "key")
                    MultipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    
                    }) {encodingResult in
                        
                    // This is what happens when the upload is complete
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        
                        upload.responseJSON(completionHandler: {response in
                            if let info = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let links = info["links"] as? Dictionary<String, AnyObject> {
                                    
                                    if let imgLink = links["image_link"] as? String {
                                        print("LINK: \(imgLink)")
                                        self.postToFirebase(imgLink)
                                    }
                                }
                            }
                        })
                        
                    case .Failure(let error):
                        print(error)
                        //Maybe show alert to user and let them try again
                    }
                }
            }else {
                self.postToFirebase(nil)
            }
        }
    }
    
    func postToFirebase(imgUrl: String?) {
        var post: Dictionary<String, AnyObject> = ["description": postField.text!, "likes": 0]
        
        if imgUrl != nil{
            post["imageUrl"] = imgUrl
        }
        let firebasePost = REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        postField.text = ""
        imageSelectorImage.image = UIImage(named: "camera")
        imageSelected = false
        tableView.reloadData()
        
    }
}
