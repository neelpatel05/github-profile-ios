//
//  ViewController.swift
//  Github Feed
//
//  Created by Neel Patel on 02/10/17.
//  Copyright © 2017 Neel Patel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var information = [String]()
    var username: String!;
    
    @IBOutlet var profileimage: UIImageView!
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //showGetUserName();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showGetUserName();
    }
    
    func showGetUserName() {
        
        let alertController = UIAlertController(title: "Welcome to Github Feed Burner!", message: "Please tell me username:", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Continue", style: .default, handler: {
            alert -> Void in
            let userNameField = alertController.textFields![0] as UITextField
            
            if userNameField.text != "" {
                self.username = userNameField.text!;
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "Please input username", preferredStyle: .alert)
                
                errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                    alert -> Void in
                    self.present(alertController, animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
            self.getUser();
        })
        
        alertController.addAction(action);
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "User Name"
            textField.textAlignment = .center
        });
        
        self.present(alertController, animated: true, completion: nil);
    }
    
    func getUser(){
        let url = "https://api.github.com/users/" + self.username;
        
        print(url);
        Alamofire.request(url).responseJSON {
            (response) in
            
            let data = response.result.value;
            
            print(JSON(data as Any));
            var jsondata = JSON(data as Any);
            
            let url = URL(string: jsondata["avatar_url"].stringValue);
            let imgdata = try? Data(contentsOf: url!)
            self.profileimage.image = UIImage(data: imgdata!)
            
            self.information.append("Name : " + jsondata["name"].stringValue);
            self.information.append("Login : " + jsondata["login"].stringValue);
            self.information.append("Location : " + jsondata["location"].stringValue);
            self.information.append("Repository : " + jsondata["public_repos"].stringValue);
            self.information.append("Followers : " + jsondata["followers"].stringValue);
            self.information.append("Following : " + jsondata["following"].stringValue);
            
            self.tableview.reloadData();
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return information.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath);
        
        cell.textLabel?.text = information[indexPath.row];
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        
        return cell
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

