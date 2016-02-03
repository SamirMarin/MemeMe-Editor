//
//  MemeDetailedViewController.swift
//  MeMeEditor
//
//  Created by Samir Marin on 2016-01-25.
//  Copyright © 2016 Samir Marin. All rights reserved.
//

import UIKit

class MemeDetailedViewController: UIViewController {
    
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    //Text attributes dictinary:
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: NSNumber(float: -1)]
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
        setTextField(topText, text: meme.topText)
        setTextField(bottomText, text: meme.bottomText)

        //referencing: https://www.hackingwithswift.com/example-code/uikit/how-to-add-a-bar-button-to-a-navigation-bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editImage:")
        navigationItem.title = ""
    }
    private func setImage(){
        imageView.image = meme.image
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
    }
    private func setTextField(textField: UITextField, text: String){
        textField.text = text
        textField.enabled = false
        textField.defaultTextAttributes = memeTextAttributes
        textField.backgroundColor = UIColor.clearColor()
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.textAlignment = NSTextAlignment.Center
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
    }

    @IBAction func editImage(sender: UIBarButtonItem) {
        let editViewController = storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        
        editViewController.topTextStringEdit = meme.topText
        editViewController.bottomTextStringEdit = meme.bottomText
        editViewController.imageEdit = meme.image
        
        presentViewController(editViewController, animated: true, completion: nil)
    }
}
