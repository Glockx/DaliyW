//
//  AppDelegate.swift
//  DaliyW
//
//  Created by Mammademin Muzaffarli on 10/5/17.
//  Copyright © 2017 Mammademin Muzaffarli. All rights reserved.
//

import UIKit
import Firebase
//import InMobiSDK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GADInterstitialDelegate {

    var window: UIWindow?
    var myInterstitial : GADInterstitial?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        //IMSdk.initWithAccountID("e71c6375cb5b484a8d7439b57f4361e8")
        GADMobileAds.configure(withApplicationID:"ca-app-pub-5739467095196341~2246383147")
        myInterstitial = createAndLoadInterstitial()
        
        // Override point for customization after application launch.
        return true
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
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

