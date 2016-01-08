//
//  Post.swift
//  SaltLife
//
//  Created by John Frost on 1/6/16.
//  Copyright © 2016 Pair-A-Dice. All rights reserved.
//

import Foundation

class Post {
    
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String!
    
    var postDescription: String {
        return _postDescription
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String {
        return _username
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(description:String, imageUrl: String?, username: String){
        self._postDescription = description
        self._imageUrl = imageUrl
        self._username = username
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>){
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }else{
            _likes = 0
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        if let desc = dictionary["description"] as? String {
            self._postDescription = desc
        }
        if let username = dictionary["username"] as? String{
            self._username = username
        }
        
    }
}