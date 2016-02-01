//
//  MemeDetailedViewController.swift
//  MeMeEditor
//
//  Created by Samir Marin on 2016-01-25.
//  Copyright © 2016 Samir Marin. All rights reserved.
//

import UIKit

class MemeDetailedViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme.memeImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
    }

}
