//
//  PrinterFunctions.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 28/1/15.
//  Copyright (c) 2015 Jesus Valladolid Rebollar. All rights reserved.
//

import Foundation

func PrintSampleReceipt3Inch(portName : NSString, portSettings : NSString, parametro : [String : AnyObject]) -> Bool {
    
    let horaActual : NSDate = NSDate()
    
    var commands = NSMutableData()
    var str : String
    var datos : NSData?
    
    var cmd : [UInt8]
    
     //Juego de caracteres en español
    cmd = [ 0x1b, 0x1d, 0x74, 0x01]
    commands.appendBytes(cmd, length: 4)
    
    // Anchura de texto
    cmd = [ 0x1b, 0x57, 0x03 ]
    commands.appendBytes(cmd, length: 3)
   

    // Texto centrado
    cmd = [ 0x1b, 0x1d, 0x61, 0x01 ]
    commands.appendBytes(cmd, length: 4)
    
    // Formato Texto : espacio entre caracteres
    cmd = [ 0x1b, 0x1e, 0x46, 0x02 ]
    commands.appendBytes(cmd, length: 4)
    
    // Inversion color
    cmd = [ 0x1b, 0x34 ]
    commands.appendBytes(cmd, length: 2)
    str = "LosBarkitos\r\n"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    
    // Formato Texto : normal
    cmd = [0x1b, 0x57, 0x2]
    commands.appendBytes(cmd, length: 3)

    str = "d'Empúriabrava\r\n\r\n"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    
    // Inversion = no
    cmd = [ 0x1b, 0x35 ]
    commands.appendBytes(cmd, length: 2)
   
    // Formato pequeño para datos empresa
    cmd = [0x1b, 0x57, 0x00]
    commands.appendBytes(cmd, length: 3)
   
    str = "Canal Vahimar S.L.\r\n N.I.F. B17825134\r\nc/ Juan Carlos I, 1\r\n17487 Empuriabrava\r\n"
    str += "Tel: 972.45.25.79\r\n"
    str += "www.marinaferry.es\r\n"
    str += "---------------------------------\r\n\r\n"
    let n : String = String(parametro["numero"] as Int)
    str += "Núm. \(n)\r\n"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)


    // tamaño mediano
    cmd = [0x1b, 0x57, 0x01]
    commands.appendBytes(cmd, length: 3)
    
    str = "Alquiler 1 hora\r\n "
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
   
    cmd = [0x1b, 0x57, 0x02]
    commands.appendBytes(cmd, length: 3)
    let b : String = parametro["barca"] as String
    println("barca \(b)")
    str = b + "\r\n\r\n"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    
    
    // tamaño pequeño
    cmd = [0x1b, 0x57, 0x00]
    commands.appendBytes(cmd, length: 3)
    // A la derecha
    cmd = [0x1b, 0x1d, 0x61, 0x02]
    commands.appendBytes(cmd, length: 4)
  
    let p : String = String(parametro["precio"] as Int)
    let iva : Double =  round(100*(parametro["precio"] as Double - (parametro["precio"] as Double / 1.21)))/100
    let pdouble : Double =  round(100*(parametro["precio"] as Double / 1.21))/100
    
    
    str = "Precio : \t \(pdouble) eur.-\r\n"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    str = "I.V.A : \t\(iva) eur.-\r\n"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    
    // tamaño mediano
    cmd = [0x1b, 0x57, 0x01]
    commands.appendBytes(cmd, length: 3)
    
    str = "Total : \(p) eur.-\r\n\r\n"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    
    cmd = [0x1b, 0x57, 0x00]
    commands.appendBytes(cmd, length: 3)
    // Centrado
    cmd = [0x1b, 0x1d, 0x61, 0x01]
    commands.appendBytes(cmd, length: 4)

    str = "I.V.A incluido en el precio\r\n"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    
    str = "----------------------------------------\r\n\r\n\r\n"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)

    
    cmd = [ 0x1b, 0x64, 0x00 ] // Corta el papel
    commands.appendBytes(cmd, length: 3)
    
    let v : String = parametro["vendedor"] as String
    str = "\n\r\n\rVendedor : \(v)\n\r\n\r"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)

    cmd = [ 0x1b, 0x64, 0x02 ] // Corta el papel
    commands.appendBytes(cmd, length: 3)
    
    str = "\n\r\n\r\n\r\n\r"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)

    
    return (sendCommand(commands,portName, portSettings,10000))
}

func PrintTotal3Inch(p_portName : NSString, p_portSettings : NSString, diccParam : [String : AnyObject]) -> Bool {
    
    let horaActual : NSDate = NSDate()
    
    var commands = NSMutableData()
    var str : String
    var datos : NSData?
    
    var cmd : [UInt8]

    //Juego de caracteres en español
    cmd = [ 0x1b, 0x1d, 0x74, 0x01]
    commands.appendBytes(cmd, length: 4)
    
    // Anchura de texto
    cmd = [ 0x1b, 0x57, 0x03 ]
    commands.appendBytes(cmd, length: 3)
    
    // Texto centrado
    cmd = [ 0x1b, 0x1d, 0x61, 0x01 ]
    commands.appendBytes(cmd, length: 4)
    
    // Formato Texto : espacio entre caracteres
    cmd = [ 0x1b, 0x1e, 0x46, 0x02 ]
    commands.appendBytes(cmd, length: 4)
    
    // Formato Texto : normal
    cmd = [0x1b, 0x57, 0x2]
    commands.appendBytes(cmd, length: 3)
    
    // Inversion = si
    cmd = [ 0x1b, 0x34 ]
    commands.appendBytes(cmd, length: 2)

    str = diccParam["p_venta"] as String
    str += "\r\n"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
   
    str = diccParam["dia"] as String
    str += "\r\n"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    
    
    // Inversion color NO
    cmd = [ 0x1b, 0x35 ]
    commands.appendBytes(cmd, length: 2)
    
    // Formato Texto : normal
    cmd = [0x1b, 0x57, 0x2]
    commands.appendBytes(cmd, length: 3)
    
    // A la derecha
    cmd = [0x1b, 0x1d, 0x61, 0x02]
    commands.appendBytes(cmd, length: 4)
    
    let Rios = diccParam["rio"] as Int
    str = "Rios : \(Rios)\n"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    
  
    let Electricas = diccParam["electrica"] as Int
    str = "Electricas : \t \(Electricas)\r\n"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)

    let Whalys = diccParam["whaly"] as Int
    str = "Whalys : \t \(Whalys)\r\n"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)

    let Golds = diccParam["gold"] as Int
    str = "Golds : \t \(Golds)\r\n\n\n"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)

    // Texto centrado
    cmd = [ 0x1b, 0x1d, 0x61, 0x01 ]
    commands.appendBytes(cmd, length: 4)

    // Inversion color
    cmd = [ 0x1b, 0x34 ]
    commands.appendBytes(cmd, length: 2)

    // Texto centrado
    cmd = [ 0x1b, 0x1d, 0x61, 0x01 ]
    commands.appendBytes(cmd, length: 4)

    str = "Total barcas : "
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    
    // Formato Texto : normal
    cmd = [0x1b, 0x57, 0x2]
    commands.appendBytes(cmd, length: 3)

    str = String(Rios + Electricas + Whalys + Golds)
    str += "\n\r"
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)

    // Inversion color
    cmd = [ 0x1b, 0x34 ]
    commands.appendBytes(cmd, length: 2)
    
    str = "Total Euros : "
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)
    
    // Formato Texto : normal
    cmd = [0x1b, 0x57, 0x2]
    commands.appendBytes(cmd, length: 3)

    str = String(diccParam["euros"] as Int)
    datos = str.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    commands.appendData(datos!)

    cmd = [ 0x1b, 0x64, 0x02 ] // Corta el papel
    commands.appendBytes(cmd, length: 3)

    
    return (sendCommand(commands, portName, p_portSettings, 10000))
}

func sendCommand(commandsToPrint : NSData, portName : NSString, portSettings: NSString, timeoutMillis : u_int) -> Bool{
    
    var starPort : SMPort
    let commandSize : Int = commandsToPrint.length as Int
 //   println("Tamaño datos a imprimir: \(commandSize)" )
    //var dataToSentToPrinter = UnsafePointer<UInt8>(commandsToPrint.bytes)
    var dataToSentToPrinter = [CUnsignedChar](count: commandsToPrint.length, repeatedValue: 0)
    //var dataToSentToPrinter = (commandsToPrint.bytes)
    
    commandsToPrint.getBytes(&dataToSentToPrinter)
    //commandsToPrint.getBytes(&dataToSentToPrinter)//, length: sizeofValue(dataToSentToPrinter))
    
    
//    println("commandstoPrint: \(commandsToPrint)")
    
  //  println("Datos : \(dataToSentToPrinter)")
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
        
        //println("commandSize : \(commandSize). dataToSEntToPrinter: \(dataToSentToPrinter)")
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
        if (status != nil) {
            starPort.endCheckedBlock(&status!, 2)
        } else {
            starPort.beginCheckedBlock(&status, 2)
            starPort.endCheckedBlock(&status!, 2)
        }
        
         //free((UnsafeMutablePointer<Void>),dataToSentToPrinter)
        SMPort.releasePort(starPort)
    } else {
        println("Error: Writte port timed out")
        return false
    }
    //free(dataToSentToPrinter)
    

    return true
}