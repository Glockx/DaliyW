//
//  AboutViewController.swift
//  DaliyW
//
//  Created by Mammademin Muzaffarli on 10/7/17.
//  Copyright © 2017 Mammademin Muzaffarli. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var backButtonPressed: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidDisappear(_ animated: Bool) {
      
    }

    @IBAction func sharePressed(_ sender: Any)
    {
        let activityVC = UIActivityViewController(activityItems: ["google.com"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
}
