//
//  AppDelegate.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 14/11/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit

// propiedades de control de la impresora

var portName : NSString = ""
var portSettings : NSString = ""
var drawerPortName : NSString = ""



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func getPortName()->NSString {
        return portName as NSString
    }
    func setPortName(nombre : NSString) {
        if portName != nombre {
            portName = nombre
        }
    }
    func getPortSettings()->NSString {
        return portSettings as NSString
    }
    func setPortSettings(settings : NSString) {
        if portSettings != settings {
            portSettings = settings
        }
    }
    func getDrawerPortName() -> NSString {
        return drawerPortName
    }
    func setDrawerPortName(portName : NSString) {
        if drawerPortName != portName {
            drawerPortName = portName.copy() as NSString
        }
    }
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // Cuando se abre la app miro si ya se ha cargado el dia
        // cargado = "si" "no"
        var cargado: String? = DataManager().getValueForKey("cargado", inFile: "appstate") as? String
        
        if (cargado == nil || cargado == "no") {
            cargarPlist_appstate(inFile: "appstate")
        }
        
        return true
        

    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    // carga el appstate con los valores correspondientes
    func cargarPlist_appstate(inFile file: String) -> String {
        
        DataManager().setValueForKey("estado_venta", value: 0, inFile: "appstate")
        
        DataManager().setValueForKey("vendedor", value: "", inFile: "appstate")
        DataManager().setValueForKey("nombre_vendedor", value: "", inFile: "appstate")
        
        DataManager().setValueForKey("rios", value: 0, inFile: "appstate")
        DataManager().setValueForKey("electricas", value: 0, inFile: "appstate")
        DataManager().setValueForKey("whalys", value: 0, inFile: "appstate")
        DataManager().setValueForKey("golds", value: 0, inFile: "appstate")
        
        DataManager().setValueForKey("lista", value: 1, inFile: "appstate")
        DataManager().setValueForKey("cargado", value: "si", inFile: "appstate")
        DataManager().setValueForKey("lista_precio", value: "1", inFile: "appstate")
        
        return "si"
        
    }

}

