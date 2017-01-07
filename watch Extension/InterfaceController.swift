//
//  InterfaceController.swift
//  watch Extension
//
//  Created by nakajijapan on 2017/01/07.
//  Copyright © 2017年 nakajijapan. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var table: WKInterfaceTable!
    @IBOutlet weak var buttonMore: WKInterfaceButton!
    var currentPage = 0
    var dataObjects: [[String: AnyObject]] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("awake")
        setTitle("Sample")
        reloadData(1)
    }
    
    func reloadData(_ page: Int) {
        let url = URL(string:"http://frustration.me/api/public_timeline?page=\(page)")!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) -> Void in
            
            let json = try! JSONSerialization.jsonObject(
                with: data!,
                options: JSONSerialization.ReadingOptions.mutableContainers
                ) as! NSDictionary
            let items = json.object(forKey: "items") as! [[String: AnyObject]] // as NSArray
            for item in items {
                self.dataObjects.append(item)
            }
            
            self.buttonMore.setTitle("More")
            if let paginator = json.object(forKey: "paginator") as? [String: Any] {
                print(paginator)
                self.currentPage = paginator["current_page"] as! Int
            }
            
            self.configureTableWithData(items)
            
        }
        dataTask.resume()
        
    }
    
    func configureTableWithData(_ items:[[String: AnyObject]]) {
        
        table.setNumberOfRows(self.dataObjects.count, withRowType: "MIRow")
        for i in 0..<self.dataObjects.count {
            
            if let row = table.rowController(at: i) as? MIRow {
                row.labelName.setText(dataObjects[i]["title"] as? String)
                
                let stringURL = dataObjects[i]["image_l"] as! String
                let url = URL(string: stringURL)
                let request = URLRequest(url:url!)
                let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
                    let image = UIImage(data: data!)
                    row.imageIcon.setImage(image)
                }
                dataTask.resume()
            }
            
        }
        
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        print("index = \(rowIndex) count \(self.dataObjects.count)" )
        return self.dataObjects[rowIndex]
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print("willActivate")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        print("didDeactivate")
    }
    
    // MARK: - Action
    @IBAction func didPushButtonMore() {
        reloadData(currentPage + 1)
    }
    
}
