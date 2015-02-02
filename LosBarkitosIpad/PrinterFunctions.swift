//
//  PrinterFunctions.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 28/1/15.
//  Copyright (c) 2015 Jesus Valladolid Rebollar. All rights reserved.
//

import Foundation

func PrintSampleReceipt3Inch(portName : NSString, portSettings : NSString, barca: String, precio: Int, nombreVendedor : String ) -> Bool {
    
    let commands = NSMutableData()

    var cmd : [UInt8] = [ 0x1b, 0x1d, 0x61, 0x01 ]
    //var cmd = "\0x1b\0x1d\0x61\0x01"
    //cmd.withCString {
      //      commands.appendBytes($0, length: 4)
    //}
    commands.appendBytes(cmd, length: 4)

       
       
    var str = barca
    var datos : NSData? = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    
    cmd = [ 0x09 ]
    //cmd = "\0x09"
    //cmd.withCString {
      //  commands.appendBytes($0, length: 1)
    //}
    commands.appendBytes(cmd, length: 1)
    
    str = String(precio)
    datos = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    
    cmd = [ 0x1b, 0x64, 0x62 ] // Corta el papel
    //cmd = "\0x1b\0x64\0x62"
    //cmd.withCString {
      //  commands.appendBytes($0, length: 3)
    //}
    commands.appendBytes(cmd, length: 3)
    
    str = nombreVendedor
    datos = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    
    cmd = [ 0x07 ] // Abre la caja
   // cmd = "\0x07"
    //cmd.withCString {
     //   commands.appendBytes($0, length: 1)
    //}
    commands.appendBytes(cmd, length: 1)
    println("Commands: \(commands)")
    return (sendCommand(commands,portName, portSettings,1000))
}

func sendCommand(commandsToPrint : NSData, portName : NSString, portSettings: NSString, timeoutMillis : u_int) -> Bool{
    
    var starPort : SMPort
    let commandSize : Int = commandsToPrint.length as Int
    println("Tamaño datos a imprimir: \(commandSize)" )
    //let dataToSentToPrinter = UnsafePointer<CUnsignedChar>(commandsToPrint.bytes)
    //var dataToSentToPrinter = [CUnsignedChar](count: commandsToPrint.length, repeatedValue: 0)
    var dataToSentToPrinter = UnsafePointer<CUnsignedChar>(commandsToPrint.bytes)
    //commandsToPrint.getBytes(&dataToSentToPrinter)//, length: sizeofValue(dataToSentToPrinter))
    
    var status : StarPrinterStatus_2? = nil
    println("commandstoPrint: \(commandsToPrint)")
    
    println("Datos : \(dataToSentToPrinter)")
    if let starPort = SMPort.getPort(portName, portSettings, timeoutMillis) {
        
        starPort.beginCheckedBlock(&status, 2)
        
        if status?.offline == 1 {
            println("Error: La impresora no esta en linea")
            return false
        }
        
        var endTime : timeval = timeval(tv_sec: 0, tv_usec: 0)
        gettimeofday(&endTime, nil)
        endTime.tv_sec += 30
        
        println("commandSize : \(commandSize). dataToSEntToPrinter: \(dataToSentToPrinter)")
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
           // starPort.endCheckedBlockTimeoutMillis = 1000
           // starPort.endCheckedBlock(&status!, 2)
           //
            return true
        }
    
        if (totalAmountWritten < UInt32(commandSize)) {
            println("Error: Impresion fuera de tiempo")
            return false
        }
        
        starPort.endCheckedBlockTimeoutMillis = 30000
        starPort.endCheckedBlock(&status!, 2)
        SMPort.releasePort(starPort)
        if (status!.offline == 1) {
            println("Error: Printer is offline")
            return false
        }
    } else {
        println("status: \(status)")

        println("Error: Writte port timed out")
        return false
    }

    return true
}