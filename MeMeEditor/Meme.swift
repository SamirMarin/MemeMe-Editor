//
//  Meme.swift
//  MeMeEditor
//
//  Created by Samir Marin on 2015-12-11.
//  Copyright © 2015 Samir Marin. All rights reserved.
//

import Foundation
import UIKit

struct Meme{
    
    let topText:String!
    let bottomText:String!
    let image: UIImage!
    let memeImage: UIImage!
    
    init(topText: String, bottomText: String, image: UIImage, memeImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memeImage = memeImage
        
    }
    
}
