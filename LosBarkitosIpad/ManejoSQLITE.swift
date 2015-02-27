//
//  ManejoSQLITE.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 27/2/15.
//  Copyright (c) 2015 Jesus Valladolid Rebollar. All rights reserved.
//

import UIkit
let sharedInstance = ManejoSQLITE()

class ManejoSQLITE : NSObject {
    var sqliteDatabase : FMDatabase? = nil
    
    class var instance: ManejoSQLITE {
        sharedInstance.sqliteDatabase = FMDatabase(path: UtilidadesBDDSQLITE.getPath("LosBarkitosSQLITE.sqlite"))
        var path = UtilidadesBDDSQLITE.getPath("LosBarkitosSQLITE.sqlite")
        println("path: \(path)")
        return sharedInstance
    }
    
    func insertaViajeSQLITE(viaje : Viaje) -> Bool {
        let consulta : String? = "INSERT INTO viaje VALUES (?, ?, ?, ?, ?, ?, ?)"
        sharedInstance.sqliteDatabase!.open()

        let estaInsertado = sharedInstance.sqliteDatabase!.executeUpdate(consulta!, withArgumentsInArray: [ viaje.numero, viaje.precio, viaje.fecha,viaje.punto_venta,viaje.barca,viaje.vendedor, 0])
        println("\(consulta)")
        sharedInstance.sqliteDatabase!.close()
        return estaInsertado
    }
}