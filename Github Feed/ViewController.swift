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
import SCLAlertView



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
        userNameEnter();
        //showGetUserName();
    }
    
    func userNameEnter(){
        
        let appearance = SCLAlertView.SCLAppearance(
            
            showCloseButton: false
            
        )
        
        let alert = SCLAlertView(appearance: appearance);
        
        
        let txt = alert.addTextField("Enter the username");

        
        alert.addButton("Continue"){
            
            if txt.text == "" {
                
                self.errorAlert();
                
            } else {
                
                self.username = txt.text?.lowercased();
                self.getUser();
            
            }
        }
        
        alert.showInfo("GitHub Feed Burner", subTitle: "Made for Developers");
    }
    
    func errorAlert() {
        
        let appearance = SCLAlertView.SCLAppearance(
            
            showCloseButton: false
            
        )
        
        let alert = SCLAlertView(appearance: appearance);

        alert.addButton("Ok"){
            
            self.userNameEnter();
            
        }
        
        alert.showError("Error", subTitle: "Username cannot be blank");
    
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
    
    //var i: Int = 0;
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return information.count;
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1;
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath);
        
        cell.textLabel?.text = information[indexPath.section];
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.textAlignment = NSTextAlignment.center;
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        cell.layer.borderWidth = 1;
        cell.layer.cornerRadius = 20;
        cell.layer.borderColor = UIColor.gray.cgColor;
        cell.clipsToBounds = true;
        
        return cell
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

