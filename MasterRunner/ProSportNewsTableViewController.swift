//
//  ProSportTableViewController.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 11/01/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import UIKit
import VK_ios_sdk

class ProSportNewsTableViewController: UITableViewController
{

    // just for test, to understand how it work
    func processingNewsRequest(responce: VKResponse<VKApiObject>) {
        // a million hours of sex to get this string
        if let wall = responce.json as? Dictionary<String,AnyObject> {
            if let items = wall["items"] as? NSArray {
                for item in items {
                    ProSportNews.proSportNews!._News += [ProSportNewsItem(dict: item as! Dictionary<String,AnyObject> )]
                }
                self.tableView.reloadData()
                print(items)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load 20 messages
        let req = VKApi.request(withMethod: "wall.get", andParameters: ["domain" : "begoman"])
        req?.addExtraParameters(["count" : 10])
        req?.execute(resultBlock: {response in
            self.processingNewsRequest(responce: response!)
        }, errorBlock: { (error) in
        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ProSportNews._proSportNews!._News.count
    }

    // 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProSportNewsCell",for: indexPath)  as! ProSportTableViewCell
        

        // Configure the cell...
        cell.textLabel?.text = ProSportNews.proSportNews?._News[indexPath.item].newsText

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
