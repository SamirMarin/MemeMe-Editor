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
    
    var topTextStringEdit: String?
    var bottomTextStringEdit: String?
    var imageEdit: UIImage?
    
    //Text attributes dictinary:
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: NSNumber(float: -1)]
    
    let memeTextEditDelegate = MemeTextEditDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        setTextField(topTextField, text: "TOP", edit: topTextStringEdit)
        setTextField(bottomTextField, text: "BOTTOM", edit: bottomTextStringEdit)
        
        //disable share button
        shareButton.enabled = false
        
        //optional image edit
        setOptionalImage(imageEdit)
        
        //the current text is set by default
        memeTextEditDelegate.isItDefaultTextTop = true
        memeTextEditDelegate.isItDefaultTextBottom = true
        
        
    }
    private func setTextField(textField: UITextField, text: String, edit: String?){
        if let textEdit = edit{
            textField.text = textEdit
        }
        else{
            textField.text = text
        }
        textField.delegate = memeTextEditDelegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.backgroundColor = UIColor.clearColor()
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.textAlignment = NSTextAlignment.Center
    }
    private func setOptionalImage(image: UIImage?){
        if let imageEdit = image{
            imageView.image = imageEdit
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            shareButton.enabled = true
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyBoardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeToKeyBoardNotifications()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
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
        presentViewController(pickImageController, animated: true, completion: nil)
        
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
        if(bottomTextField.isFirstResponder()){
            view.frame.origin.y -= heightOfKeyBoard(notification)
        }
    }
    func keyBoardWillHide(notification: NSNotification){
        view.frame.origin.y = 0
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
        
        navigationController?.setToolbarHidden(true, animated: false)
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        //render the view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navigationController?.setToolbarHidden(false, animated: false)
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
        return memeImage
    }
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func shareImage(sender: UIBarButtonItem) {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        let memeImage = createMemeImage()
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {(activity, success, items, error) in
            if(success){
                self.save(memeImage)
                activityViewController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    func save(memeImage: UIImage){
       let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image!, memeImage: memeImage)
        
        //adding meme to Memes array in appDelegate
        let appDelegateOption = UIApplication.sharedApplication().delegate
        let appDelegate = appDelegateOption as! AppDelegate
        appDelegate.memes.append(meme)
        //dissmissing viewController
        dismissViewControllerAnimated(true, completion: {self.postNotification("load")
                                                        self.postNotification("cload")})
    }
    private func postNotification(aName: String){
        NSNotificationCenter.defaultCenter().postNotificationName(aName, object: nil)
    }
}

