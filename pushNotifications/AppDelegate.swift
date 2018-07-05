//
//  AppDelegate.swift
//  pushNotifications
//
//  Created by Alex Kisel on 7/3/18.
//  Copyright © 2018 BRANDER. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("received push = \(UserDefaults.standard.bool(forKey: "receivedPush"))")
      
        UNUserNotificationCenter.current().delegate = self
        if #available(iOS 12.0, *) {
          UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge, .providesAppNotificationSettings]) { (_, _) in }
            //let summaryFormat = NSString.localizedUserNotificationString(forKey: "NOTIFICATION_SUMMARY", arguments: nil)
          
            let likeAction = UNNotificationAction(identifier: "com.suchapp.like", title: "Like", options: [])
          
            let category = UNNotificationCategory(identifier: "com.suchapp",
                                                  actions: [likeAction],
                                                  intentIdentifiers: [],
                                                  options: [])
          
          UNNotificationCategory.init(identifier: "com.suchapp",
                                      actions: [likeAction],
                                      intentIdentifiers: [],
                                      hiddenPreviewsBodyPlaceholder: nil,
                                      categorySummaryFormat: "Еще %u сообщений от %@",
                                      options: [])
          
            UNUserNotificationCenter.current().setNotificationCategories([category])
        } else {
            // Fallback on earlier versions
        }
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = 0
        return true
    }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    UserDefaults.standard.set(true, forKey: "receivedPush")
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
    print("open new vc")
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    print("action id = \(response.actionIdentifier)")
    completionHandler()
  }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .alert, .badge])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("token = \(token)")
    }
}

