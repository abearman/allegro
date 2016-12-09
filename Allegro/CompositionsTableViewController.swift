//
//  CompositionsTableViewController.swift
//  Allegro
//
//  Created by Amy Bearman on 12/6/16.
//  Copyright © 2016 Amy Bearman. All rights reserved.
//

import UIKit

class CompositionsTableViewController: UITableViewController {
  
  var compositions: [Composition] = [Composition]()

  override func viewDidLoad() {
    super.viewDidLoad()
  
    self.navigationController?.isNavigationBarHidden = false

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }

  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = true
  }

  
  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return compositions.count
  }

  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Composition Cell", for: indexPath)
    
    let composition = compositions[indexPath.row]
    cell.textLabel?.text = composition.name

    return cell
  }
 
  
  /* Load the Composition in the composeVC */
  /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "Edit Composition", sender: self)
  }*/
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Edit Composition" {
      if let revealVC = segue.destination as? SWRevealViewController {
        revealVC.loadView()
        if let composeVC = revealVC.frontViewController as? ComposeViewController {
          
          let indexPath = self.tableView.indexPathForSelectedRow
          composeVC.composition = compositions[(indexPath?.row)!]
          //revealVC.loadView()
        }
      }
    }
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
