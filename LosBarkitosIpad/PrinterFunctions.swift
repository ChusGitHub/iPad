//
//  PrinterFunctions.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 28/1/15.
//  Copyright (c) 2015 Jesus Valladolid Rebollar. All rights reserved.
//

import Foundation

func PrintSampleReceipt3Inch(portName : NSString, portSettings : NSString, barca: String, precio: Int, nombreVendedor : String ) -> Bool {
    
    var commands = NSMutableData()

    var cmd : [UInt8] = [ 0x1b, 0x1d, 0x61, 0x01 ]

    commands.appendBytes(cmd, length: 4)
    println(commands)
       
       
    var str = barca + "\r\n\r\n"
    //var datos : NSData? = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
    //commands.appendData(datos!)
    //println(commands)
    var datos : NSData? = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    println(commands)
    
    //str = "123 Star Road\r\nCity, State 12345\r\n\r\n"
    str = "Precio \(precio)\r\n\r\n"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    println(commands)
    
    cmd = [ 0x1b, 0x1d, 0x61, 0x00]
    commands.appendBytes(UnsafePointer(cmd), length: 4)
    println(commands)
    //cmd = [ 0x09 ]
    //cmd = "\0x09"
    //cmd.withCString {
      //  commands.appendBytes($0, length: 1)
    //}
   // commands.appendBytes(cmd, length: 1)
    //println(commands)
    
    //str = String(precio)
    //datos = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
    //commands.appendData(datos!)
     // println(commands)
    cmd = [ 0x1b, 0x64, 0x02 ] // Corta el papel
    //cmd = "\0x1b\0x64\0x62"
    //cmd.withCString {
      //  commands.appendBytes($0, length: 3)
    //}
    commands.appendBytes(cmd, length: 3)
      println(commands)
    //str = nombreVendedor
    //datos = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
    //commands.appendData(datos!)
      //println(commands)
    //cmd = [ 0x07 ] // Abre la caja
   // cmd = "\0x07"
    //cmd.withCString {
     //   commands.appendBytes($0, length: 1)
    //}
   // commands.appendBytes(cmd, length: 1)
    println("Commands: \(commands)")
    return (sendCommand(commands,portName, portSettings,10000))
}

func sendCommand(commandsToPrint : NSData, portName : NSString, portSettings: NSString, timeoutMillis : u_int) -> Bool{
    
    var starPort : SMPort
    let commandSize : Int = commandsToPrint.length as Int
    println("Tamaño datos a imprimir: \(commandSize)" )
    //var dataToSentToPrinter = UnsafePointer<UInt8>(commandsToPrint.bytes)
    var dataToSentToPrinter = [CUnsignedChar](count: commandsToPrint.length, repeatedValue: 0)
    //var dataToSentToPrinter = (commandsToPrint.bytes)
    
    commandsToPrint.getBytes(&dataToSentToPrinter)
    //commandsToPrint.getBytes(&dataToSentToPrinter)//, length: sizeofValue(dataToSentToPrinter))
    
    
    println("commandstoPrint: \(commandsToPrint)")
    
    println("Datos : \(dataToSentToPrinter)")
    if let starPort = SMPort.getPort(portName, portSettings, timeoutMillis) {
        
        var status : StarPrinterStatus_2? = nil
        starPort.beginCheckedBlock(&status, 2)
        
        if status?.offline == 1 {
            println("Error: La impresora no esta en linea")
            return false
        }
        
        var endTime : timeval = timeval(tv_sec: 0, tv_usec: 0)
        gettimeofday(&endTime, nil)
        endTime.tv_sec += 30
        
        println("commandSize : \(commandSize). dataToSEntToPrinter: \(dataToSentToPrinter)")
        var totalAmountWritten : Int = 0
        while (Int(totalAmountWritten) < commandSize) {
            let remaining : Int  = (UInt32(commandSize) - UInt32(totalAmountWritten))
            let amountWritten : UInt32 = starPort.writePort(dataToSentToPrinter, UInt32(totalAmountWritten),UInt32(remaining))
            totalAmountWritten = Int(totalAmountWritten) + Int(amountWritten)
            
            var now : timeval = timeval(tv_sec: 0, tv_usec: 0)
            gettimeofday(&now, nil)
            if (now.tv_sec > endTime.tv_sec) {
                break
            }
           // starPort.endCheckedBlockTimeoutMillis = 1000
           // starPort.endCheckedBlock(&status!, 2)
           
        }
    
        if (UInt32(totalAmountWritten) < UInt32(commandSize)) {
            println("Error: Impresion fuera de tiempo")
            return false
        }
        
        starPort.endCheckedBlockTimeoutMillis = 30000
        starPort.endCheckedBlock(&status!, 2)
        
        if (status!.offline == 1) {
            println("Error: Printer is offline")
            return false
        }
        SMPort.releasePort(starPort)
    } else {
        println("Error: Writte port timed out")
        return false
    }
    //free(dataToSentToPrinter)
    

    return true
}