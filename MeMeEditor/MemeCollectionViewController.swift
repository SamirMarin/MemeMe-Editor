//
//  MemeCollectionViewController.swift
//  MeMeEditor
//
//  Created by Samir Marin on 2016-01-11.
//  Copyright © 2016 Samir Marin. All rights reserved.
//
import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]!
    var space: CGFloat = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppDelegate()
        
        let dimension = getDimension()
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }    
    private func getDimension() ->  CGFloat{
        if(UIApplication.sharedApplication().statusBarOrientation.isPortrait){
            return (view.frame.size.width - 2*space)/3.0
        }
        else{
            return (view.frame.size.height - 2*space)/3.0
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        subscribeToLoadNotification()
        reloadCollection()
    }
    func loadCollection(notification: NSNotification){
        reloadCollection()        
    }
    private func reloadCollection(){
        collectionView?.reloadData()

    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(true)
        unSubscribeToLoadNotification()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        setAppDelegate()
    }
    
    private func subscribeToLoadNotification(){
        //obtained from: http://stackoverflow.com/questions/25921623/how-to-reload-tableview-from-another-view-controller-in-swift
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadCollection:", name: "cload", object: nil)
    }
    private func unSubscribeToLoadNotification(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "cload", object: nil)
    }
    
    private func setAppDelegate(){
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCellCollection", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.memeImage.image = meme.memeImage
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailedController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailedViewController") as! MemeDetailedViewController
        detailedController.meme = memes[indexPath.item]
        navigationController!.pushViewController(detailedController, animated: true)
    }
    
    @IBAction func memeEdit(sender: UIBarButtonItem) {
        let detailedController = storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        presentViewController(detailedController, animated: true, completion: nil)
    }
}
