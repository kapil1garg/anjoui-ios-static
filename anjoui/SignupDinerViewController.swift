//
//  SignupDinerViewController.swift
//  anjoui
//
//  Copyright (c) 2015 anjoui. All rights reserved.
//

import UIKit


class SignupDinerViewController: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBAction func dinerSignup(sender: UIButton) {
        let user_first_name:String = (txtFirstName.text! as String).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let user_last_name:String = (txtLastName.text! as String).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let user_email:String = (txtEmail.text! as String).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let user_password:String = txtPassword.text! as String
        
        if (user_first_name == "" || user_last_name == "" || user_email == "" || user_password == "") {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Required fields blank"
            alertView.message = "Please fill First Name, Last Name, Email, and Password fields"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else if (!user_email.isValidEmail()) {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Invalid email"
            alertView.message = "Email must be in the format: example@anjoui.com"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            // create post data string
            let post:NSString = "first_name=\(user_first_name)&last_name=\(user_last_name)&email=\(user_email)&password=\(user_password)"
            NSLog("PostData: %@",post);
            
            // create connection URL
            let url: NSURL = NSURL(string: "http://ec2-52-23-188-123.compute-1.amazonaws.com/anjoui/create.php")!
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
                    
                    let alertView:UIAlertView = UIAlertView()
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    
                    if (res.statusCode == 200) {
                        self.performSegueWithIdentifier("diner_signup", sender: nil)
                        alertView.title = "Welcome to anjoui!"
                        alertView.message = "Congratulations! Your diner account was created successfully."
                    } else if (res.statusCode == 500) {
                        alertView.title = "Sign in Failed"
                        alertView.message = "Connection Failure"
                    } else if (res.statusCode == 409) {
                        alertView.title = "Email already exists"
                        alertView.message = "This email already exists. Please use another email or log in."
                    }
                    alertView.show()
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
