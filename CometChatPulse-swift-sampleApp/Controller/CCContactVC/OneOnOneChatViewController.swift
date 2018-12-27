//
//  OneOnOneChatViewController.swift
//  CCPulse-CometChatUI-ios-master
//
//  Created by pushpsen airekar on 02/12/18.
//  Copyright © 2018 Admin1. All rights reserved.
//

import UIKit

class OneOnOneChatViewController: UIViewController,UITextViewDelegate,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var chatInputView: UITextView!
    @IBOutlet weak var chatTableview: UITableView!
    //Outlets Declarations
   
    // Variable Declarations
    var buddyNameString:String!
    var buddyStatusString:String!
    //var buddyAvtar:String!
    var buddyAvtar:UIImage!
    var buddyName:UILabel!
    var buddyStatus:UILabel!
    
    let chatMessage = [ Message(messageText: "Hello Pushpsen", userID: "12", avatarURL: "default", messageType: "10", isSelf: false, isGroup: true),
                        Message(messageText: "Hi this is my first text message", userID: "12", avatarURL: "default", messageType: "10", isSelf: true, isGroup: true),
                        Message(messageText: "I want to have a string that is actually very long in length so that I can get a very large string at the o/p", userID: "12", avatarURL: "default", messageType: "10", isSelf: true, isGroup: true),
                        Message(messageText: "I want to have a string that is actually very long in length so that I can get a very large string at the o/p I want to have a string that is actually very long in length so that I can get a very large string at the o/p", userID: "12", avatarURL: "default", messageType: "10", isSelf: false, isGroup: true),  Message(messageText: "Hi Jeet", userID: "12", avatarURL: "default", messageType: "10", isSelf: false, isGroup: true)
                        ]
    
    
    
    
    fileprivate let cellID = "chatCell"
//    let chatMessages = ["Hi this is my first text message", "I want to have a string that is actually very long in length so that I can get a very large string at the o/p", "I want to have a string that is actually very long in length so that I can get a very large string at the o/p I want to have a string that is actually very long in length so that I can get a very large string at the o/p","Hi Jeet"]
    
    //This method is called when controller has loaded its view into memory.
    override func viewDidLoad() {
        super.viewDidLoad()

        print("buddyNameis: \(String(describing: buddyNameString))")
    //Function Calling
        self.handleOneOnOneChatVCApperance()
       
        self.chatView.layer.borderWidth = 1
        self.chatView.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        self.chatView.layer.cornerRadius = 20.0
        self.chatView.clipsToBounds = true
        self.chatInputView.delegate = self
        chatInputView.text = "Type a message..."
        chatInputView.textColor = UIColor.lightGray
        
        chatTableview.delegate = self
        chatTableview.dataSource = self
        
        //registerCell
        chatTableview.register(ChatTableViewCell.self, forCellReuseIdentifier: cellID)
        chatTableview.separatorStyle = .none
        
        //chatView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func handleOneOnOneChatVCApperance(){
        
        // ViewController Appearance
        self.hidesBottomBarWhenPushed = true
        navigationController?.navigationBar.isTranslucent = false
        guard (UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView) != nil else {
            return
        }
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        } else {
            
        }
        // NavigationBar Buttons Appearance
        
        let backButtonImage = UIImageView(image: UIImage(named: "back_arrow"))
        backButtonImage.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let backBTN = UIBarButtonItem(image: backButtonImage.image,
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        backBTN.tintColor = UIColor.white
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        //BuddyAvtar Apperance
        //buddyAvtar = UIImage(named: "ic_person.png")
        let containView = UIView(frame: CGRect(x: -10 , y: 0, width: 38, height: 38))
        containView.backgroundColor = UIColor.white
        containView.layer.cornerRadius = 19
        containView.layer.masksToBounds = true
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageview.image = buddyAvtar
        imageview.contentMode = UIView.ContentMode.scaleAspectFill
        imageview.layer.cornerRadius = 19
        imageview.layer.masksToBounds = true
        containView.addSubview(imageview)
        let leftBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.leftBarButtonItems?.append(leftBarButton)
        
        //TitleView Apperance
        let  titleView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        self.navigationItem.titleView = titleView
        
        buddyName = UILabel(frame: CGRect(x:0,y: 3,width: 200,height: 21))
        buddyName.textColor = UIColor.white
        buddyName.textAlignment = NSTextAlignment.left
        buddyName.text = buddyNameString
        buddyName.font = UIFont(name: "AvenirNext-Medium", size: 18)
        titleView.addSubview(buddyName)
        
        buddyStatus = UILabel(frame: CGRect(x:0,y: titleView.frame.origin.y + 22,width: 200,height: 21))
        buddyStatus.textColor = UIColor.white
        buddyStatus.textAlignment = NSTextAlignment.left
        buddyStatus.text = buddyStatusString
        buddyStatus.font = UIFont(name: "AvenirNext-Medium", size: 12)
        titleView.addSubview(buddyStatus)
        
        
        // More Actions:
        let tapOnProfileAvtar = UITapGestureRecognizer(target: self, action: #selector(UserAvtarClicked(tapGestureRecognizer:)))
        imageview.isUserInteractionEnabled = true
        imageview.addGestureRecognizer(tapOnProfileAvtar)
        
        
        let tapOnTitleView = UITapGestureRecognizer(target: self, action: #selector(TitleViewClicked(tapGestureRecognizer:)))
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(tapOnTitleView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func UserAvtarClicked(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileAvtarViewController = storyboard.instantiateViewController(withIdentifier: "ccprofileAvtarViewController") as! CCprofileAvtarViewController
        navigationController?.pushViewController(profileAvtarViewController, animated: true)
        profileAvtarViewController.title = buddyNameString
        profileAvtarViewController.profileAvtar = buddyAvtar
        profileAvtarViewController.hidesBottomBarWhenPushed = true
    }
    
    
    @objc func TitleViewClicked(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let UserProfileViewController = storyboard.instantiateViewController(withIdentifier: "userProfileViewController") as! UserProfileViewController
        navigationController?.pushViewController(UserProfileViewController, animated: true)
        UserProfileViewController.title = "View Profile"
        UserProfileViewController.getUserProfileAvtar = buddyAvtar
        UserProfileViewController.getUserName = buddyName.text
        UserProfileViewController.getUserStatus = buddyStatus.text
        UserProfileViewController.hidesBottomBarWhenPushed = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let userinfo = notification.userInfo
        {
            let keyboardFrame = (userinfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            
            self.view.frame.origin.y = -keyboardFrame!.height;
            print(-keyboardFrame!.height)
        }
        
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("In keyboardWillHide")
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if chatInputView.textColor == UIColor.lightGray {
            chatInputView.text = ""
            chatInputView.textColor = UIColor.black
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableViewCell
        
        let messageData = chatMessage[indexPath.row]
        
        cell.chatMessage = messageData
        //cell.isIncomingMessage = messageData.isSelf
        return cell
        
    }
    
    
    @IBAction func sendButton(_ sender: Any) {
        print(chatInputView.text!)
        
    }
    


}


//move this to different file
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
