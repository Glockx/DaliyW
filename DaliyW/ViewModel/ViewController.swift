//
//  ViewController.swift
//  DaliyW
//
//  Created by Mammademin Muzaffarli on 10/5/17.
//  Copyright © 2017 Mammademin Muzaffarli. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import Photos


class ViewController: UIViewController
{
    //var
    @IBOutlet weak var HomeScreenView: UIButton!
    @IBOutlet weak var lockScreenView: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var blurSelected: UIButton!
    @IBOutlet weak var MainView: UIImageView!
    var imageId = ""
    var ref: DocumentReference!
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    var clampFilter: CIFilter!
    var transform: CGAffineTransform!
    var beginImage: CIImage!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var LockButtonCenter: CGPoint!
    var homeButtonCenter: CGPoint!
    
    //viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        context = CIContext(options: nil)
        currentFilter = CIFilter(name: "CIGaussianBlur")
        clampFilter = CIFilter(name: "CIAffineClamp")
        clampFilter.setDefaults()
        transform = CGAffineTransform.identity
        
        LockButtonCenter = lockButton.center
        homeButtonCenter = homeButton.center
        
        lockButton.center = previewButton.center
        homeButton.center = previewButton.center
        
        ref = Firestore.firestore().document("Days/0wAS7rrHbAf3c3nY131F")
        readData()
        
        slider?.addTarget(self, action: #selector(ViewController.didChangeSliderValue(_:)), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(readData),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if(blurSelected.isSelected)
        {
            getimage()
            applyProcessing()
        }
    }
    
    
    //showing image on the Interface
    func getimage()
    {
        let splash = Splash(id: imageId,size: (1242, 2208))
        MainView.sd_setImage(with: splash.url, placeholderImage: #imageLiteral(resourceName: "Solids-black"), options: [.progressiveDownload, .continueInBackground], completed: nil)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
        {
            self.currentImage = self.MainView.image
            print("done")
        }
    }
    
    //blur slider button
    @IBAction func getBlured(_ sender: Any)
    {
        if (slider.isHidden == true)
        {
            slider.isEnabled = true
            slider.value = 50
            slider.isHidden = false
            applyProcessing()
        }
        else
        {
            slider.value = 0
            applyProcessing()
            slider.isHidden = true
            
        }
        
        
    }
    //saving current image
    @IBAction func SaveImage(_ sender: Any)
    {
       appDelegate.myInterstitial?.present(fromRootViewController: self)
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: self.MainView.image!)
        }, completionHandler: { success, error in
            if success {
                // Saved successfully!
                
            }
            else if error != nil {
                // Save photo failed with error
            }
            else {
                // Save photo failed with no error
            }
        })
    }
    
    //Firebase connection
    @objc func readData()
    {
        let today = Date().dayOfWeek()! as String?
        ref.getDocument { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else{return}
            let myData = docSnapshot.data()
            let day = myData[today!] as? String ?? ""
            self.imageId = day
            self.getimage()
            print(self.imageId)
            
        }
    }
    
    //slider
    @IBAction func didChangeSliderValue(_ sender: UISlider)
    {
        applyProcessing()
    }
    //Blur Processor
    func applyProcessing()
    {
        let beginImage = CIImage(image: self.currentImage)
        
        clampFilter.setValue(beginImage, forKey: "inputImage")
        clampFilter.setValue(transform, forKey: "inputTransform")
        
        currentFilter.setValue(self.clampFilter.outputImage, forKey: kCIInputImageKey)
        currentFilter.setValue(slider.value, forKey: kCIInputRadiusKey)
        
        let cgimage = context.createCGImage(currentFilter.outputImage!, from: (beginImage?.extent)!)
        let processedImage = UIImage(cgImage: cgimage!)
        
        MainView.image = processedImage
    }
    @IBAction func lockScreenViewPressed(_ sender: Any)
    {
        if(lockScreenView.alpha == 1)
        {
            UIView.animate(withDuration: 0.3, animations:
                {
                    self.blurSelected.isHidden=false
                    self.saveButton.isHidden=false
                    self.aboutButton.isHidden=false
                    self.homeButton.isHidden=false
                    self.lockButton.isHidden=false
                    self.saveButton.isHidden=false
                    self.previewButton.isHidden = false
                    if(self.slider.isHidden == true)
                    {
                        self.slider.isEnabled = false
                        self.slider.isHidden = true
                    }else{
                        self.slider.alpha = 1
                    }
                    self.lockScreenView.alpha = 0
            })
        }
    }
        
    @IBAction func lockScreenPressed(_ sender: Any)
    {
        if(lockScreenView.alpha == 0)
        {
            UIView.animate(withDuration: 0.3, animations:
                {
                    self.blurSelected.isHidden=true
                    self.saveButton.isHidden=true
                    self.aboutButton.isHidden=true
                    self.homeButton.isHidden=true
                    self.lockButton.isHidden=true
                    self.saveButton.isHidden=true
                    self.previewButton.isHidden = true
                    if(self.slider.isHidden == true)
                    {
                        
                    }
                    else{
                        self.slider.alpha = 0
                    }
                    
                    self.lockScreenView.alpha = 1
            })
        }
    }
    
    @IBAction func homeScreenViewPressed(_ sender: Any)
    {
        if(HomeScreenView.alpha == 1)
        {
            UIView.animate(withDuration: 0.3, animations:
                {
                    self.blurSelected.isHidden=false
                    self.saveButton.isHidden=false
                    self.aboutButton.isHidden=false
                    self.homeButton.isHidden=false
                    self.lockButton.isHidden=false
                    self.saveButton.isHidden=false
                    self.previewButton.isHidden = false
                    if(self.slider.isHidden == true)
                    {
                        self.slider.isEnabled = false
                        self.slider.isHidden = true
                    }else{
                        self.slider.alpha = 1
                    }
                    self.HomeScreenView.alpha = 0
            })
        }
    }
    //home button pressed
    @IBAction func homeScreenPressed(_ sender: Any)
    {
        if(HomeScreenView.alpha == 0)
        {
            UIView.animate(withDuration: 0.3, animations:
                {
                    self.blurSelected.isHidden=true
                    self.saveButton.isHidden=true
                    self.aboutButton.isHidden=true
                    self.homeButton.isHidden=true
                    self.lockButton.isHidden=true
                    self.saveButton.isHidden=true
                    self.previewButton.isHidden = true
                    if(self.slider.isHidden == true)
                    {
                        
                    }
                    else{
                        self.slider.alpha = 0
                    }
                    
                    self.HomeScreenView.alpha = 1
            })
        }
    }
    
    @IBAction func previewButtonPressed(_ sender: Any)
    {
        if (lockButton.alpha == 0)
        {
            UIView.animate(withDuration: 0.3, animations:
            {
                self.lockButton.alpha = 1
                self.homeButton.alpha = 1
                //animate here
                self.lockButton.center = self.LockButtonCenter
                self.homeButton.center = self.homeButtonCenter
                
            })
        }
        else{
        
            UIView.animate(withDuration: 0.3, animations:
                {
                    self.lockButton.alpha = 0
                    self.homeButton.alpha = 0
            self.lockButton.center = self.previewButton.center
            self.homeButton.center = self.previewButton.center
        })
    }
}
    
}
