//
//  AppDelegate.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 24/05/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import Network
import WebKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    public var internetStatus = false
    var internetType = ""


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = {
            path in
            if path.status != .satisfied{
                self.internetStatus = false
            }else{
                self.internetStatus = true
                if path.usesInterfaceType(.wifi){
                    self.internetType = "wifi"
                }
                else if path.usesInterfaceType(.cellular){
                    self.internetType = "Cellular"
                }
            }
        } // Espera un closure?(funcion anonima) se ejecuta de manera asincrona
        monitor.start(queue: DispatchQueue.global())
        sleep(1)
        if internetStatus {
            DataPerdidos.instance.getInfo()
            DataAdoptable.instance.getInfo()
            if Auth.auth().currentUser != nil{
                DataManager.instance.getInfo()
            }
        }

        return true
    }
		
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        sleep(2)
        return true
    }
    func hayInternet()->Bool{
        return internetStatus
    }

}

