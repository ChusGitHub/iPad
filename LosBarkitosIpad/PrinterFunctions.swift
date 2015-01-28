//
//  PrinterFunctions.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 28/1/15.
//  Copyright (c) 2015 Jesus Valladolid Rebollar. All rights reserved.
//

import Foundation

func PrintSampleReceipt3Inch(portName : NSString, portSettings : NSString) {
    
    let commands = NSMutableData()

    var cmd = "\0x1b\0x1d\0x61\0x01"
    cmd.withCString {
        commands.appendBytes($0, length: 4)

    }
       
       
    var str = "Hola"
    var datos : NSData? = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    
    cmd = "\0x09}"
    commands.appendBytes(&cmd, length: 1)
    
    str = "Esto se acaba"
    datos = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    
    cmd = "\0x1b\0x64\0x62}" // Corta el papel
    commands.appendBytes(&cmd, length: 3)
    
    cmd = "\0x07}" // Abre la caja
    commands.appendBytes(cmd, length: 1)
    
    sendCommand(commands,portName, portSettings,10000)
}

func sendCommand(commandsToPrint : NSData, portName : NSString, portSettings: NSString, timeoutMillis : u_int) {
    
    var starPort : SMPort
    let commandSize : Int = commandsToPrint.length as Int
    let dataToSentToPrinter = UnsafePointer<CUnsignedChar>(commandsToPrint.bytes)
    
    if let starPort = SMPort.getPort(portName, portSettings, timeoutMillis) {
        var status : StarPrinterStatus_2? = nil
        starPort.beginCheckedBlock(&status, 2)
        
        if status?.offline == 1 {
            println("Error: La impresora no esta en linea")
            return
        }
        
        var endTime : timeval = timeval(tv_sec: 0, tv_usec: 0)
        gettimeofday(&endTime, nil)
        endTime.tv_sec += 30
        
        var totalAmountWritten : UInt32 = 0
        while (Int(totalAmountWritten) < commandSize) {
            let remaining : UInt32  = (UInt32(commandSize) - totalAmountWritten)
            let amountWritten  = starPort.writePort(dataToSentToPrinter, totalAmountWritten, remaining)
            totalAmountWritten += amountWritten
            
            var now : timeval = timeval(tv_sec: 0, tv_usec: 0)
            gettimeofday(&now, nil)
            if (now.tv_sec > endTime.tv_sec) {
                break
            }
        }
        
        if (totalAmountWritten < UInt32(commandSize)) {
            println("Error: Impresion fuera de tiempo")
        }
        
        starPort.endCheckedBlockTimeoutMillis = 30000
        starPort.endCheckedBlock(&status!, 2)
        if (status!.offline == 1) {
            println("Error: Printer is offline")
        }
        
    } else {
        println("Error: Writte port timed out")
    }
    
}