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
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as! String
        let path = documentsFolder.stringByAppendingPathComponent(fileName)
        println(path)
        
        return path
    }
    
    class func copyFile(fileName : NSString) {
        var dbPath : String = getPath(fileName as String)

        var fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(dbPath) {
            var fromPath : String? = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent(fileName as String)
            
            fileManager.copyItemAtPath(fromPath!, toPath: dbPath, error: nil)
        }
    }
}