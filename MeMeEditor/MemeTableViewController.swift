//
//  MemeTableViewController.swift
//  MeMeEditor
//
//  Created by Samir Marin on 2016-01-11.
//  Copyright © 2016 Samir Marin. All rights reserved.
//

import UIKit


class MemeTableViewController: UITableViewController {
    
    
    var memes: [Meme]!
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppDelegate()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        subscribeToLoadNotification()
        reloadTable()
        
    }
    func loadTable(notification: NSNotification){
        reloadTable()
    }
    private func reloadTable(){
        tableView.reloadData()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        unSubscribeToLoadNotification()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        setAppDelegate()
    }
    private func subscribeToLoadNotification(){
        //obtained from: http://stackoverflow.com/questions/25921623/how-to-reload-tableview-from-another-view-controller-in-swift
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadTable:", name: "load", object: nil)
    }
    private func unSubscribeToLoadNotification(){
        NSNotificationCenter.defaultCenter().removeObserver("load")
    }
    private func setAppDelegate(){
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCellTable")!
        let meme = memes[indexPath.row]

        // Configure the cell...
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText
        cell.imageView?.image = meme.image
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        cell.detailTextLabel?.text = "Meme"
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailedController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailedViewController") as! MemeDetailedViewController
        detailedController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailedController, animated: true)
    }
    
    
    @IBAction func memeEditor(sender: UIBarButtonItem) {
        let detailedController = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        presentViewController(detailedController, animated: true, completion: nil)
        
    }
}
