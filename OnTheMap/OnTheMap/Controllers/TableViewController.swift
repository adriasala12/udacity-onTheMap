//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Adrià Sala Roget on 30/04/2020.
//  Copyright © 2020 Adrià Sala Roget. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var results: [Students.Location]!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Students.results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let locationForRow = Students.results[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = String(locationForRow.firstName + " " + locationForRow.lastName)
        cell.imageView?.image = UIImage(named: "pinImage")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = Students.results[(indexPath as NSIndexPath).row]
        guard let url = URL(string: student.mediaURL) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: {success in
            if !success {
                let alertVC = UIAlertController(title: "Invalid URL", message: "This student has not provided a valid URL.", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.navigationController?.present(alertVC, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func postLocationTapped(_ sender: Any) {
        User.postLocationRequest()
        
        let postLocationVC = self.storyboard!.instantiateViewController(withIdentifier: "postLocation")
        postLocationVC.modalPresentationStyle = .fullScreen
        present(postLocationVC, animated: true, completion: nil)

    }
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        Students.reload()
        self.tableView.reloadData()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        User.deleteSessionRequest()
        self.dismiss(animated: true, completion: nil)
    }
    
}
