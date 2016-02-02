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
        //referencing: https://www.hackingwithswift.com/example-code/uikit/how-to-add-a-bar-button-to-a-navigation-bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editImage:")
        navigationItem.title = ""
    }

    @IBAction func editImage(sender: UIBarButtonItem) {
        let editViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        
        editViewController.topTextStringEdit = meme.topText
        editViewController.bottomTextStringEdit = meme.bottomText
        editViewController.imageEdit = meme.image
        
        presentViewController(editViewController, animated: true, completion: nil)
    }
}
