//
//  ViewController.swift
//  MeMeEditor
//
//  Created by Samir Marin on 2015-12-06.
//  Copyright © 2015 Samir Marin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    
    //Text attributes dictinary:
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: NSNumber(float: 3)]
    
    let memeTextEditDelegate = MemeTextEditDelegate()
    
    //position of keyboard constants
    var positionAtOrgin: CGFloat?
    var positionAtKeyBoardHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        //setting text field delegates
        topTextField.delegate = memeTextEditDelegate
        bottomTextField.delegate = memeTextEditDelegate
        //the current text is set by default
        memeTextEditDelegate.isItDefaultTextTop = true
        memeTextEditDelegate.isItDefaultTextBottom = true
        
        //set text field attributes
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        //center the text
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        positionAtOrgin = view.frame.origin.y
        subscribeToKeyBoardNotifications()
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeToKeyBoardNotifications()
        
    }
    @IBAction func selectImage(sender: UIBarButtonItem) {
        let pickImageController = UIImagePickerController()
        pickImageController.delegate = self
        pickImageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickImageController, animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        let pickImageController = UIImagePickerController()
        pickImageController.delegate = self
        pickImageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
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
    
    func keyBoardWillShow(notification: NSNotification){
        if let position = positionAtOrgin{
            if(position == view.frame.origin.y){
                view.frame.origin.y -= heightOfKeyBoard(notification)
                if positionAtKeyBoardHeight == nil{
                    positionAtKeyBoardHeight = view.frame.origin.y
                }
            }
        }
    }
    func keyBoardWillHide(notification: NSNotification){
        if let position = positionAtKeyBoardHeight{
            if (position == view.frame.origin.y){
                view.frame.origin.y += heightOfKeyBoard(notification)
            }
        }
    }
    func heightOfKeyBoard(notification: NSNotification)->CGFloat{
        let userInfo = notification.userInfo
        let keyBoardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyBoardSize.CGRectValue().height
    }
    
    func subscribeToKeyBoardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    func unSubscribeToKeyBoardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func createMemeImage() -> UIImage{
        //hide tool bar to make UIImage -- from : https://www.veasoftware.com/tutorials/2015/1/12/show-and-hide-bottom-toolbar-in-swift-xcode-6-ios-8-tutorial
        
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        //render the view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        return memeImage
    }
    
    @IBAction func shareImage(sender: UIBarButtonItem) {
        let memeImage = createMemeImage()
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {(activity, success, items, error) in
            if(success){
                self.save()
                activityViewController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
                
        
        
        
    }
    func save(){
       _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image!, memeImage: createMemeImage())
        
    }
    
    

}

