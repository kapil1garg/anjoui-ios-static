//
//  LoginViewController.swift
//  anjoui
//
//  Copyright (c) 2015 anjoui. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func loginClick(sender: UIButton) {
        // Authenticate user
        let user_email:String = (txtEmail.text! as String).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).lowercaseString
        let user_password:String = txtPassword.text! as String
        
        // check for valid input
        if (user_email == "" || user_password == "") {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Please enter Email and Password"
            alertView.message = "Email and Password fields cannot be blank."
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else if (!user_email.isValidEmail()){
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Invalid email"
            alertView.message = "Email must be in the format: example@anjoui.com"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            // create post data string
            let post:NSString = "email=\(user_email)&password=\(user_password)"
            NSLog("PostData: %@",post);
            
            // create connection URL
            let url: NSURL = NSURL(string: "http://ec2-52-23-188-123.compute-1.amazonaws.com/anjoui/login.php")!
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            let postLength:NSString = String( postData.length )
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            var response: NSURLResponse?
            do {
                let urlData: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
                if ( urlData != nil ) {
                    let res = response as! NSHTTPURLResponse!;
                    NSLog("Response code: %ld", res.statusCode);
                    
                    if (res.statusCode == 200) {
                        do {
                            let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                            self.performSegueWithIdentifier("login_user", sender: nil)
                        } catch let error as NSError {
                            print(error)
                        }
                    } else if (res.statusCode == 403) {
                        let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                        
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        
                        if (responseData == "Password is incorrect." || responseData == "Email does not exist.") {
                            alertView.message = responseData as String
                        } else {
                            alertView.message = "Connection Failed"
                            
                        }
                        alertView.show()
                    }
                } else {
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed"
                    alertView.message = "Connection Failure"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
