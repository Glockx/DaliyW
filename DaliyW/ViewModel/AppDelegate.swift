//
//  AppDelegate.swift
//  DaliyW
//
//  Created by Mammademin Muzaffarli on 10/5/17.
//  Copyright © 2017 Nijat Muzaffarli. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GADInterstitialDelegate {
    var window: UIWindow?
    var myInterstitial : GADInterstitial?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
                _ = Pushbots(appId:"59e759709b823aa32f8b4572", prompt: true)
               Pushbots.sharedInstance().trackPushNotificationOpened(launchOptions: launchOptions)

        if launchOptions != nil {
            if let userInfo = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary {
                //Capture notification data e.g. badge, alert and sound
                if let aps = userInfo["aps"] as? NSDictionary {
                    let alert = aps["alert"] as! String
                    print("Notification message: ", alert);
                    //UIAlertView(title:"Push Notification!", message:alert, delegate:nil, cancelButtonTitle:"OK").show()
                }
                
                //Capture custom fields
                if let articleId = userInfo["articleId"] as? NSString {
                    print("ArticleId: ", articleId);
                }
            }
        }
 
        
        application.registerForRemoteNotifications()
        do {
            Network.reachability = try Reachability(hostname: "www.google.com")
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
          updateUserInterface()
            return true
    }
    
  
    func application(_ application: UIApplication,  didReceiveRemoteNotification userInfo: [AnyHashable : Any],  fetchCompletionHandler handler: @escaping (UIBackgroundFetchResult) -> Void) {
        //Track notification only if the application opened from Background by clicking on the notification.
        if application.applicationState == .inactive  {
            Pushbots.sharedInstance().trackPushNotificationOpened(withPayload: userInfo);
        }
        
        //The application was already active when the user got the notification, just show an alert.
        //That should *not* be considered open from Push.
        if application.applicationState == .active  {
            //Capture notification data e.g. badge, alert and sound
            if let aps = userInfo["aps"] as? NSDictionary {
                let alert_message = aps["alert"] as! String
                let alert = UIAlertController(title: "title",
                                              message: alert_message,
                                              preferredStyle: .alert)
                let defaultButton = UIAlertAction(title: "OK",
                                                  style: .default) {(_) in
                                                    // your defaultButton action goes here
                }
                
                alert.addAction(defaultButton)
                self.window?.rootViewController?.present(alert, animated: true) {
                    // completion goes here
                }
            }
        }
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // This method will be called everytime you open the app
        // Register the deviceToken on Pushbots
        Pushbots.sharedInstance().register(onPushbots: deviceToken);
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Notification Registration Error \(error)")
    }
    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            print("unreacble appDelegate")
        case .wifi:
            GADMobileAds.configure(withApplicationID:"ca-app-pub-5739467095196341~2246383147")
            myInterstitial = createAndLoadInterstitial()
            print("wifi delegate")
        case .wwan:
            GADMobileAds.configure(withApplicationID:"ca-app-pub-5739467095196341~2246383147")
            myInterstitial = createAndLoadInterstitial()
            print("mobile data delegate")
        }
    }
                    
    @objc func statusManager(_ notification: NSNotification) {
        updateUserInterface()
    }
    

    
    func createAndLoadInterstitial()->GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-5739467095196341/3274547878")
        interstitial.delegate = self
        let request = GADRequest()
        //request.testDevices = [kGADSimulatorID,"6d8ea70952482d44d7cf7816b2f2e4d9"]
        interstitial.load(request)
        return interstitial
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print(error.localizedDescription)
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        myInterstitial = createAndLoadInterstitial()
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
       updateUserInterface()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}
