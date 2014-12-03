//
//  PlistData.swift
//  LosBarkitosIpad
//
//  Created by chus on 14/11/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//

import Foundation


class DataManager: NSObject {
    
    /**
    Guarda en una .plist valores
    
    :param: key   la key donde debe almacenarlo
    :param: value el valor a guardar
    :param: file  el fichero a generar
    */
    func setValueForKey(key: String, value: AnyObject, inFile file:String) {
        
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent(file)
        let filename = path + ".plist"
        
        var dict = NSMutableDictionary(contentsOfFile: filename)
        
        if dict == nil {
            dict = NSMutableDictionary()
        }
        
        dict?.setValue(value, forKey: key)
        dict?.writeToFile(filename, atomically: true)
        
    }
    
    /**
    Carga de una .plist valores
    
    :param: key  la key a cargar
    :param: file el fichero a leer
    
    :returns: el valor encontrado
    */
    func getValueForKey(key: String, inFile file:String) -> AnyObject? {
        
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent(file)
        let filename = path + ".plist"
        
        var dict = NSMutableDictionary(contentsOfFile: filename)?
        
        if dict? != nil {
            return dict?.valueForKey(key)
        }
        else {
            return nil
        }
        
    }
    
}