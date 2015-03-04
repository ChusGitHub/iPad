//
//  UtilidadesBDDSQLITE.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 27/2/15.
//  Copyright (c) 2015 Jesus Valladolid Rebollar. All rights reserved.
//

import Foundation
import UIKit

class UtilidadesBDDSQLITE : NSObject {
    
    class func getPath(fileName : String) -> String {
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = documentsFolder.stringByAppendingPathComponent(fileName)
        println(path)
        
        return path
        //return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent(fileName)
    }
    
    class func copyFile(fileName : NSString) {
        var dbPath : String = getPath(fileName)
        println(dbPath)

        var fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(dbPath) {
            var fromPath : String? = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent(fileName)
            
            fileManager.copyItemAtPath(fromPath!, toPath: dbPath, error: nil)
        }
    }
}