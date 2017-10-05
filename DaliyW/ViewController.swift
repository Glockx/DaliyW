//
//  ViewController.swift
//  DaliyW
//
//  Created by Mammademin Muzaffarli on 10/5/17.
//  Copyright © 2017 Mammademin Muzaffarli. All rights reserved.
//

import UIKit

import Firebase

class ViewController: UIViewController {

    var imageId = ""
    var ref: DocumentReference!
    
    
    @IBOutlet weak var MainView: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ref = Firestore.firestore().document("Days/0wAS7rrHbAf3c3nY131F")
        // Do any additional setup after loading the view, typically from a nib.
        readData()
        NotificationCenter.default.addObserver(self, selector: #selector(readData), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    func getimage()
    {
        let splash = Splash(id: imageId,size: (750, 1334))
        print(splash.url)
        splash.get { image in
            self.MainView.image = image
        }
    }
    @objc public func readData()
    {
        let today = Date().dayOfWeek()! as String?
        
        ref.getDocument { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else{return}
            let myData = docSnapshot.data()
            let day = myData[today!] as? String ?? ""
            self.imageId = day
            self.getimage()
        }
    }
}

