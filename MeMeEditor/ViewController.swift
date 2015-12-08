//
//  ViewController.swift
//  MeMeEditor
//
//  Created by Samir Marin on 2015-12-06.
//  Copyright © 2015 Samir Marin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func selectImage(sender: UIBarButtonItem) {
        let pickImageController = UIImagePickerController()
        pickImageController.delegate = self
        self.presentViewController(pickImageController, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
        }
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

