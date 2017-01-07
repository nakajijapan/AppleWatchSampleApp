//
//  DetailInterfaceController.swift
//  AppleWatchSample
//
//  Created by nakajijapan on 2017/01/07.
//  Copyright © 2017年 nakajijapan. All rights reserved.
//

import WatchKit
import Foundation

class DetailInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var imageItem: WKInterfaceImage!
    @IBOutlet weak var labelTitle: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let item = context as? Dictionary<String, AnyObject> {
            if let title = item["title"] as? String {
                self.labelTitle.setText(title)
            }
            
            if let stringURL = item["image_l"] as? String {
                
                let url = URL(string: stringURL)
                let request = URLRequest(url:url!)
                let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
                    let image = UIImage(data: data!)
                    self.imageItem.setImage(image)
                }
                dataTask.resume()
                
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
