//
//  ManejoSQLITE.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 27/2/15.
//  Copyright (c) 2015 Jesus Valladolid Rebollar. All rights reserved.
//

//import UIkit
let sharedInstance = ManejoSQLITE()

class ManejoSQLITE : NSObject {
    var sqliteDatabase : FMDatabase? = nil
    var sqliteDatabasePath : String? = nil
    
    class var instance: ManejoSQLITE {
        sharedInstance.sqliteDatabase = FMDatabase(path: UtilidadesBDDSQLITE.getPath("LosBarkitosSQLITE.sqlite"))
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        sharedInstance.sqliteDatabasePath = documentsFolder.stringByAppendingPathComponent("LosBarkitosSQLITE.sqlite")

        //let path = UtilidadesBDDSQLITE.getPath("LosBarkitosSQLITE.sqlite")
        println("path: \(sharedInstance.sqliteDatabasePath)")
        return sharedInstance
    }
    
    func insertaViajeSQLITE(viaje : Viaje) -> Bool {
        //let consulta : String? = "INSERT INTO viaje VALUES (?, ?, ?, ?, ?, ?, ?)"
        
        var filemgr = NSFileManager.defaultManager()
        if filemgr.fileExistsAtPath(sharedInstance.sqliteDatabasePath!) {
            if sharedInstance.sqliteDatabase!.open() {
                let consulta : String? = "INSERT INTO viaje VALUES (?,?,?,?,?,?,?)"
                if !sharedInstance.sqliteDatabase!.executeUpdate(consulta!, withArgumentsInArray: [viaje.numero, viaje.precio, viaje.fecha, viaje.punto_venta, viaje.barca, viaje.vendedor, viaje.blanco]) {
                    println("\(sqliteDatabase!.lastError()) - \(sqliteDatabase!.lastErrorMessage())")
                }
                sharedInstance.sqliteDatabase!.close()
            }
        }
        
        
        
        //let estaInsertado = sharedInstance.sqliteDatabase!.executeUpdate(consulta!, withArgumentsInArray: [ viaje.numero, viaje.precio, viaje.fecha,viaje.punto_venta,viaje.barca,viaje.vendedor, viaje.blanco])
//        let estaInsertado = sharedInstance.sqliteDatabase!.executeUpdate(consulta!, withArgumentsInArray: nil)
        
  //      println("\(consulta!)")
       // sharedInstance.sqliteDatabase!.close()
    //    return estaInsertado
        return true
        
    }
    
    func numeroBarcas() -> Int32 {
        var numBarcas : Int32 = 0
        var filemgr = NSFileManager.defaultManager()
        if filemgr.fileExistsAtPath(sharedInstance.sqliteDatabasePath!) {
            if sharedInstance.sqliteDatabase!.open() {
                let consulta : String? = "SELECT count(*) from viaje"
                let resultado : FMResultSet? = sharedInstance.sqliteDatabase!.executeQuery(consulta!, withArgumentsInArray: nil)
                if let resultado = resultado where resultado.next() {
                     numBarcas = resultado.intForColumnIndex(0) as Int32
                } else {
                    numBarcas = 0
                }
                sharedInstance.sqliteDatabase!.close()
            }
        }
        return numBarcas
    }
}