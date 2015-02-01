//
//  Conectividad.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 21/11/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//

import Foundation

class Conectividad : NSObject {
    func estaConectado () -> Bool {
    println("ENTRA")
        let reachability : Reachability = Reachability.reachabilityForInternetConnection()
        
        reachability.whenReachable = { reachability in
           
            if reachability.isReachableViaWiFi() {
                println("Reachable via WIFI")
            } else {
                println("Reachable via Cellular")
            }
            
        }
        reachability.startNotifier()
        return true
    }
}