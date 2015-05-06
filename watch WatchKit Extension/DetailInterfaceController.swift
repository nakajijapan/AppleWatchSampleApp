//
//  DetailInterfaceController.swift
//  watch
//
//  Created by nakajijapan on 5/4/15.
//  Copyright (c) 2015 net.nakajijapan. All rights reserved.
//

import WatchKit
import Foundation

class DetailInterfaceController: WKInterfaceController {

    @IBOutlet weak var imageItem: WKInterfaceImage!
    @IBOutlet weak var labelTitle: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        println(context)
        if let item = context as? Dictionary<String, AnyObject> {
            if let title = item["title"] as? String {
                self.labelTitle.setText(title)
            }
            
            if let stringURL = item["image_l"] as? String {
                
                let url = NSURL(string: stringURL)
                let request = NSURLRequest(URL:url!)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
                    let image = UIImage(data: data)
                    self.imageItem.setImage(image)
                }
            }

        }
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
