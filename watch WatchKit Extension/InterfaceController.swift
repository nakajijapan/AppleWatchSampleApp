//
//  InterfaceController.swift
//  watch WatchKit Extension
//
//  Created by nakajijapan on 5/3/15.
//  Copyright (c) 2015 net.nakajijapan. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    var currentPage = 0
    var dataObjects:Array<Dictionary<String, AnyObject>>! = []
    
    @IBOutlet weak var buttonMore: WKInterfaceButton!
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        println("awakeWithContext")
        self.setTitle("Sample")
        self.reloadData(1)
    }
    
    func reloadData(page: Int) {
        let url            = NSURL(string:"http://frustration.me/api/public_timeline?page=\(page)")!
        let request        = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            var json = NSJSONSerialization.JSONObjectWithData(
                data,
                options: NSJSONReadingOptions.MutableContainers,
                error: nil) as! NSDictionary
            
            var items = json.objectForKey("items") as! Array<Dictionary<String, AnyObject>> // as NSArray

            for item in items {
                self.dataObjects.append(item)
            }
            
            self.buttonMore.setTitle("More")

            self.currentPage = json.objectForKey("paginator")!.objectForKey("current_page") as! Int
            println("current page = \(self.currentPage)")
            
            self.configureTableWithData(items)
            
        }

    }
    
    func configureTableWithData(items:Array<Dictionary<String, AnyObject>>) {

        self.table.setNumberOfRows(self.dataObjects.count, withRowType: "MIRow")
        for i in 0..<self.dataObjects.count {
            println("awakeWithContext \(i)")
            
            var row = self.table.rowControllerAtIndex(i) as! MIRow
            row.labelName.setText(self.dataObjects[i]["title"] as? String)
            
            let stringURL = self.dataObjects[i]["image_l"] as! String
            let url = NSURL(string: stringURL)
            let request = NSURLRequest(URL:url!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
                let image = UIImage(data: data)
                row.imageIcon.setImage(image)
            }

        }
        
    }

    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        println("index = \(rowIndex) count \(self.dataObjects.count)" )
        return self.dataObjects[rowIndex]
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        println("willActivate")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        println("didDeactivate")

    }
    
    // MARK: - Action
    @IBAction func didPushButtonMore() {
        self.reloadData(self.currentPage + 1)
    }
    

}
