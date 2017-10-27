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
import Hero
import NVActivityIndicatorView
import SDWebImage
import ChameleonFramework

class ViewController: UIViewController
{
    
    
    //var
    var progView:DRGradientProgressView!
    var i:CGFloat!
    @IBOutlet weak var lockScreenReal: UIImageView!
    @IBOutlet weak var homeViewReal: UIImageView!
    @IBOutlet weak var HomeScreenView: UIButton!
    @IBOutlet weak var lockScreenView: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var errorView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var blurSelected: UIButton!
    @IBOutlet weak var MainView: UIImageView!
    var imageId = ""
    var newId = ""
    var unchanged = ""
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
    var activityIndicator : NVActivityIndicatorView!
    let defaults = UserDefaults.standard
    //viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        progView = DRGradientProgressView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 6))
        progView.progress = 1
        
        ref =  Firestore.firestore().document("Days/0wAS7rrHbAf3c3nY131F")
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        let frame = CGRect(x: (xAxis - 35), y: (yAxis - 45), width: 60, height: 60)
        activityIndicator = NVActivityIndicatorView(frame: frame)
        activityIndicator.type = . ballBeat // add your type
        activityIndicator.color = UIColor.gray // add your color
     
        
        Pushbots.sharedInstance().clearBadgeCount();
     
        
        context = CIContext(options: nil)
        currentFilter = CIFilter(name: "CIGaussianBlur")
        clampFilter = CIFilter(name: "CIAffineClamp")
        clampFilter.setDefaults()
        transform = CGAffineTransform.identity
     

 
        
        LockButtonCenter = lockButton.center
        homeButtonCenter = homeButton.center
        
        lockButton.center = previewButton.center
        homeButton.center = previewButton.center
        
        slider?.addTarget(self, action: #selector(ViewController.didChangeSliderValue(_:)), for: .valueChanged)
        
        //checking the program entered to foreground
       NotificationCenter.default.addObserver(self, selector: #selector(readData),
                                              name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        //checking the time changes
       NotificationCenter.default.addObserver(self, selector: #selector(readData),
                                              name: NSNotification.Name.UIApplicationSignificantTimeChange, object: nil)
        //checking internet status
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        
      
        
        updateUserInterface()
     
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        if let temnewid = defaults.string(forKey: "newId"){
            self.newId =  temnewid
            //defaults.removeObject(forKey: "newId")
        }
        if let temimageid = defaults.string(forKey: "unchanged"){
            self.imageId = temimageid
           // defaults.removeObject(forKey: "imageId")
        }
        if imageId != ""{
            getimage()
        }else{
            readData()
        }
    }

    
    override func viewDidAppear(_ animated: Bool)
    {
        if(blurSelected.isSelected)
        {
            getimage()
            applyProcessing()
        }
    }
 

    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            print("not av")
        case .wifi:
            print("wifi")
        case .wwan:
            print("mobile data")
        }
    }
    @objc func statusManager(_ notification: NSNotification) {
        updateUserInterface()
    }
    func hideactivityIndicator()
    {
        
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    //showing image on the Interface
    func getimage()
    {
        self.view.addSubview(progView)
        let splash = Splash(id: imageId,size: (1125, 2436))
        if Network.reachability?.isConnectedToNetwork == false  && MainView.image == nil
        {
            MainView.image = UIImage(named: "38459")
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            blurSelected.isHidden = true
            saveButton.isHidden = true
            previewButton.isHidden = true
        }else if Network.reachability?.isConnectedToNetwork == false && MainView.image != nil
        {
            MainView.image = UIImage(named: "38459")
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            blurSelected.isHidden = true
            saveButton.isHidden = true
            previewButton.isHidden = true
        }
        else{
            blurSelected.isHidden = false
            saveButton.isHidden = false
            previewButton.isHidden = false
            SDWebImageManager.shared().loadImage(with: splash.url, options: [], progress: nil, completed: { (Image, Data, Error, Cache, Bool, URL) in
                self.MainView.image = Image
                self.progView.removeFromSuperview()
                self.setDefs()
            })
        }
            currentImage = MainView.image
            print("done")
        }
    
    //blur slider button
    @IBAction func getBlured(_ sender: Any) 
    {
        getimage()
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
    
    @IBAction func secondTransition(_ sender: Any)
    {
        let aboutVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC2") as! AboutViewController
        aboutVC.isHeroEnabled = true
        aboutVC.heroModalAnimationType = .fade
        self.hero_replaceViewController(with: aboutVC)
    }
 
    //saving current image
    @IBAction func SaveImage(_ sender: Any)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
        {
            self.appDelegate.myInterstitial?.present(fromRootViewController: self)
            self.slider.isHidden = true
        }
 
        UIImageWriteToSavedPhotosAlbum(MainView.image!, self,#selector(self.image(image:didFinishSavingWithError:contextInfo:)) , nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer)
    {
        guard error == nil else {
            //Error saving image
            let ac = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            ac.view.layer.cornerRadius = 25
            ac.view.alpha = 0.8
            present(ac, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                ac.dismiss(animated: true, completion: nil)
            }
            return
        }
        //Image saved successfully
        let ac = UIAlertController(title: "Saved", message: "The Wallpaper has been saved\n to your photos.", preferredStyle: .alert)
        ac.view.layer.cornerRadius = 25
        ac.view.alpha = 0
        present(ac, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ac.dismiss(animated: true, completion: nil)
        }
    }
    
    //Firebase connection
    @objc func readData()
    {
            let todayy = Date().dayNumberOfWeek()!
            ref.getDocument {
                (docSnapshot, error) in
                guard let docSnapshot = docSnapshot else{return}
                let myData = docSnapshot.data()
                let day = myData[String(todayy)] as? String
                self.newId = day!
                self.unchanged = day!
                print(self.imageId)
                
                self.imageId = self.newId
                self.getimage()
                
        }
    }
    
    @objc func setDefs(){
        self.defaults.set(self.newId, forKey: "newId")
        self.defaults.set(self.imageId, forKey: "unchanged")
        
        print("I'm done setting defaults")
    }
    
    //slider
    @IBAction func didChangeSliderValue(_ sender: UISlider)
    {
        applyProcessing()
    }
    //Blur Processor
    func applyProcessing()
    {
        let beginImage = CIImage(image: self.currentImage!)
        
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
                    self.saveButton.isHidden=false
                    if(self.slider.isHidden == true)
                    {
                        self.slider.isEnabled = false
                        self.slider.isHidden = true
                    }else{
                        self.slider.alpha = 1
                    }
                    self.lockScreenReal.alpha = 0
                    self.lockScreenView.alpha = 0
            })
        }
       self.previewButton.isHidden = false
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
                    self.saveButton.isHidden=true
                    if(self.slider.isHidden == true)
                    {
                        
                    }
                    else{
                        self.slider.alpha = 0
                    }
                    self.lockScreenReal.alpha = 1
                    self.lockScreenView.alpha = 1
            })
        }
        self.homeButton.alpha = 0
        self.lockButton.alpha = 0
        self.previewButton.isHidden = true
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
                    
                    self.saveButton.isHidden=false
                    
                    if(self.slider.isHidden == true)
                    {
                        self.slider.isEnabled = false
                        self.slider.isHidden = true
                    }else{
                        self.slider.alpha = 1
                    }
                    self.homeViewReal.alpha = 0
                    self.HomeScreenView.alpha = 0
            })
        }
        self.previewButton.isHidden = false
       
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
                    self.saveButton.isHidden=true
                    if(self.slider.isHidden == true)
                    {
                        
                    }
                    else{
                        self.slider.alpha = 0
                    }
                    self.homeViewReal.alpha = 1
                    self.HomeScreenView.alpha = 1
            })
        }
        self.homeButton.alpha = 0
        self.lockButton.alpha = 0
        self.previewButton.isHidden = true
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
