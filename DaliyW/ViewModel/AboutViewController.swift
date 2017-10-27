//
//  AboutViewController.swift
//  DaliyW
//
//  Created by Mammademin Muzaffarli on 10/7/17.
//  Copyright © 2017 Mammademin Muzaffarli. All rights reserved.
//

import UIKit
import Hero
import MessageUI
class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
    @IBAction func goBack(_ sender: UIButton)
    {
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC1") as! ViewController
        mainVC.isHeroEnabled = true
        mainVC.heroModalAnimationType = .fade
        self.hero_replaceViewController(with: mainVC)
    }
    
    @IBAction func sharePressed(_ sender: Any)
    {
        let activityVC = UIActivityViewController(activityItems: ["https://itunes.apple.com/us/app/dailyw/id1295015357?ls=1&mt=8"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    @IBAction func contactPressed(_ sender: UIButton)
    {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            
        }
    }
    
    @IBAction func submitPressed(_ sender: UIButton)
    {
        UIApplication.shared.openURL(URL(string: "https://form.jotform.me/72861562014453")!)
    }
  
    @IBAction func reviewPressed(_ sender: UIButton)
    {
        UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/gb/app/id1295015357?action=write-review&mt=8")!)
    }
    
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["nicat7546@gmail.com"])
        mailComposerVC.setSubject("DayliW Contact")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
