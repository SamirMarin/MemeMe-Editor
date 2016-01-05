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
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    //Text attributes dictinary:
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: NSNumber(float: -1)]
    
    let memeTextEditDelegate = MemeTextEditDelegate()
    
    //position of keyboard constants
    var positionAtOrgin: CGFloat? = 0
    var positionAtKeyBoardHeight: CGFloat?
    
    //The meme object
    var meme: Meme?
    
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
        
        //set text field backGroundColor
        topTextField.backgroundColor = UIColor.clearColor()
        bottomTextField.backgroundColor = UIColor.clearColor()
        topTextField.borderStyle = UITextBorderStyle.RoundedRect
        bottomTextField.borderStyle = UITextBorderStyle.RoundedRect
        
        //center the text
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        //disable share button
        shareButton.enabled = false
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyBoardNotifications()
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeToKeyBoardNotifications()
        
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        if(positionAtKeyBoardHeight != nil){
          // positionAtKeyBoardHeight = nil
        }
    }
    @IBAction func selectImage(sender: UIBarButtonItem) {
        pickAnImage(UIImagePickerControllerSourceType.PhotoLibrary)

    }
    
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        pickAnImage(UIImagePickerControllerSourceType.Camera)
        
    }
    private func pickAnImage(sourceType: UIImagePickerControllerSourceType){
        let pickImageController = UIImagePickerController()
        pickImageController.delegate = self
        pickImageController.sourceType = sourceType
        self.presentViewController(pickImageController, animated: true, completion: nil)
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
        }
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        shareButton.enabled = true
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyBoardWillShow(notification: NSNotification){
        if let positionOrgin = positionAtOrgin{
            if(positionOrgin == view.frame.origin.y){
                view.frame.origin.y -= heightOfKeyBoard(notification)
                }
            }else{
                view.frame.origin.y = 0
                view.frame.origin.y -= heightOfKeyBoard(notification)
            }
        if positionAtKeyBoardHeight == nil{
            positionAtKeyBoardHeight = view.frame.origin.y
        }
    }
    func keyBoardWillHide(notification: NSNotification){
        if let positionAtHeight = positionAtKeyBoardHeight{
            if(positionAtHeight == view.frame.origin.y){
                view.frame.origin.y += heightOfKeyBoard(notification)
                positionAtKeyBoardHeight = nil
            }
        }
    }
    func heightOfKeyBoard(notification: NSNotification)->CGFloat{
        let userInfo = notification.userInfo
        let keyBoardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyBoardSize.CGRectValue().height
    }
    func subscribeToKeyBoardNotifications(){
        addingObserver("keyBoardWillShow:", name: UIKeyboardWillShowNotification)
        addingObserver("keyBoardWillHide:", name: UIKeyboardWillHideNotification)
    }
    private func addingObserver(selectorFunc: Selector, name: String?){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selectorFunc, name: name, object: nil)
        
    }
    func unSubscribeToKeyBoardNotifications(){
        removingObserver(UIKeyboardWillShowNotification)
        removingObserver(UIKeyboardWillHideNotification)
    }
    private func removingObserver(name: String?){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: name, object: nil)
    }
    func createMemeImage() -> UIImage{
        //hide tool bar to make UIImage -- from : https://www.veasoftware.com/tutorials/2015/1/12/show-and-hide-bottom-toolbar-in-swift-xcode-6-ios-8-tutorial
        
        self.navigationController?.setToolbarHidden(true, animated: false)
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        //render the view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
        return memeImage
    }
    @IBAction func cancel(sender: UIBarButtonItem) {
        viewDidLoad()
        imageView.image = nil
    }
    @IBAction func shareImage(sender: UIBarButtonItem) {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        let memeImage = createMemeImage()
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {(activity, success, items, error) in
            if(success){
                self.save(memeImage)
                activityViewController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    func save(memeImage: UIImage){
       meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image!, memeImage: memeImage)
        
    }
}

