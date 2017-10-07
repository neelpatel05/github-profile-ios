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
import ChameleonFramework
import Kingfisher


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var mainview: UIView!
    var information = [String]();
    var userrepos = [String]();
    var userfollowers = [String]();
    var userfollowing = [String]();
    var htmlurl = [String]();
    var repolanguage = [String]();
    var repobranch = [String]();
    var repodescription = [String]();
    var username: String!;
    var identities = ["A","B","C","D","E","F"];
    
    @IBOutlet var profileimage: UIImageView!
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //showGetUserName();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        mainview.backgroundColor = UIColor.flatPowderBlue;
        tableview.backgroundColor = UIColor.flatPowderBlue;
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
                self.getUserRepos();
                self.getUserFollowing();
                self.getUserFollowers();
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
            
            //print(JSON(data as Any));
            let jsondata = JSON(data as Any);
            
            let url = URL(string: jsondata["avatar_url"].stringValue);
            
            _ = try? Data(contentsOf: url!)
            
            self.profileimage.kf.indicatorType = .activity;
            
            self.profileimage.kf.setImage(with: url, placeholder: "Downloading" as? Placeholder, options: nil, progressBlock: nil, completionHandler: nil);
            self.profileimage.layer.borderWidth = 2;
            
            self.information.append("Name : " + jsondata["name"].stringValue);
            
            self.information.append("Login : " + jsondata["login"].stringValue);
            
            self.information.append("Location : " + jsondata["location"].stringValue);
            
            self.information.append("Repository : " + jsondata["public_repos"].stringValue);
            
            self.information.append("Followers : " + jsondata["followers"].stringValue);
            
            self.information.append("Following : " + jsondata["following"].stringValue);
            
            self.mainview.backgroundColor = UIColor.flatWhite;
            self.tableview.reloadData();
        }
    }

    func getUserRepos() {
        
        let url = "https://api.github.com/users/"+self.username+"/repos";
        
        Alamofire.request(url).responseJSON {
            (reponse) in
            
            let data = reponse.result.value;
            
            let jsondata = JSON(data as Any);
            
            print(jsondata.count);
            
            for i in 0..<jsondata.count {
                
                self.userrepos.append(jsondata[i]["name"].stringValue);
                
                self.htmlurl.append(jsondata[i]["html_url"].stringValue);
                self.repolanguage.append(jsondata[i]["language"].stringValue);
                self.repobranch.append(jsondata[i]["default_branch"].stringValue);
                self.repodescription.append(jsondata[i]["description"].stringValue);
                
                
            }
            
            for i in 0..<self.userrepos.count {
                
                print(self.userrepos[i]);
               // print(self.htmlurl[i]);
                
            }
        }
        
        
    }
    
    func getUserFollowers(){
        
        let url = "https://api.github.com/users/"+self.username+"/followers";
        
        print(url)
        
        Alamofire.request(url).responseJSON {
            
            (response) in
            
            let data = response.result.value;
            //print(JSON(data as Any));
            
            let jsondata = JSON(data as Any);
            
            for i in 0..<jsondata.count {
                
                self.userfollowers.append(jsondata[i]["login"].stringValue);
                
            }
            
            for i in 0..<jsondata.count {
                
                print(self.userfollowers[i]);
                
            }
            
        }
        
        
    }
    
    func getUserFollowing() {
        
        let url = "https://api.github.com/users/" + self.username + "/following";
        
        
        Alamofire.request(url).responseJSON {
            (response) in
            
            let data = response.result.value;
            
            //print(JSON(data as Any));
            
            let jsondata = JSON(data as Any);
            
            for i in 0..<jsondata.count {
                
                self.userfollowing.append(jsondata[i]["login"].stringValue);
                
            }
            
            for i in 0..<jsondata.count {
                
                print(self.userfollowing[i]);
                
            }
            
        }
        
        
    }
    
    
    //var i: Int = 0;
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return information.count;
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1;
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath);
        
        cell.backgroundColor = UIColor.flatWhiteDark;
        cell.textLabel?.text = information[indexPath.section];
        cell.textLabel?.textColor = UIColor.flatBlue;
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.textAlignment = NSTextAlignment.center;
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        cell.layer.borderWidth = 0;
        cell.layer.cornerRadius = 0;
        cell.layer.borderColor = UIColor.gray.cgColor;
        cell.clipsToBounds = true;
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let indexPath = tableView.indexPathForSelectedRow;
        let cell = tableView.cellForRow(at: indexPath!);
        
        let txt = cell?.textLabel?.text;
        let index = txt?.index((txt?.startIndex)!, offsetBy: 7)
    
        let name = txt?.substring(to: index!)
        
        if(name=="Name : "){
            
            let alert = SCLAlertView();
            alert.showInfo("Name", subTitle: "\(self.information[0])");
            
        }else if(name == "Login :"){
            
            let alert = SCLAlertView();
            alert.showInfo("Username", subTitle: "\(self.information[1])");
            
        }else if(name=="Locatio"){
            
            let alert = SCLAlertView();
            alert.showInfo("Location", subTitle: "\(self.information[2])");
            
        }else if(name=="Reposit"){

            let alertcontroller = UIAlertController(title: "Repository", message: self.username + "has following Repository", preferredStyle: .actionSheet);
            
            for i in 0..<self.userrepos.count {
                
                //let rawurl = "https://github.com/"+self.username+"/"+self.userrepos[i]+"/";
                //let url = NSURL(String(rawurl));
                alertcontroller.addAction(UIAlertAction(title: self.userrepos[i], style: .default, handler: { action in
                    
                    let alertcontroller = UIAlertController(title: self.userrepos[i], message: "Language : " + self.repolanguage[i] + "\n" + "Branch : " + self.repobranch[i] + "\nDescription : " + self.repodescription[i], preferredStyle: .alert);
                    
                    let alert = UIAlertAction(title: "Ok", style: .cancel, handler: nil);
                    
                    alertcontroller.addAction(alert);
                    
                    self.present(alertcontroller, animated: true, completion: nil);
                    
                }));
                
            }
            
            alertcontroller.addAction(UIAlertAction(title: "Done", style: .default, handler: nil));
            
            self.present(alertcontroller, animated: true, completion: nil);
            
//            let alert = SCLAlertView();
//            alert.showInfo("Repository", subTitle: "\(self.information[3])");
//            
        }else if(name=="Followe"){
            
            let alertcontroller = UIAlertController(title: "Followers", message: self.username + "has following followers", preferredStyle: .actionSheet);
            
            for i in 0..<self.userfollowers.count {
                
                alertcontroller.addAction(UIAlertAction(title: self.userfollowers[i], style: .default, handler: nil))
                
            }
            
            alertcontroller.addAction(UIAlertAction(title: "Done", style: .default, handler: nil));
            
            self.present(alertcontroller, animated: true, completion: nil);
            
//            let alert = SCLAlertView();
//            alert.showInfo("Followers", subTitle: "\(self.information[4])");
            
        }else if(name=="Followi"){

            
            let alertcontroller = UIAlertController(title: "Following", message: self.username + "is following", preferredStyle: .actionSheet);
            
            for i in 0..<self.userfollowing.count {
                
                alertcontroller.addAction(UIAlertAction(title: self.userfollowing[i], style: .default, handler: nil))
                
            }
            
            alertcontroller.addAction(UIAlertAction(title: "Done", style: .default, handler: nil));
            
            self.present(alertcontroller, animated: true, completion: nil);
            
//            let alert = SCLAlertView();
//            alert.showInfo("Following", subTitle: "\(self.information[5])");
//            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

