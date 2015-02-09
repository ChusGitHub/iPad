//
//  Conexion.swift
//  LosBarkitosIpad
//  Esta clase implementa  las llamadas al webservice
//  Created by Jesus Valladolid Rebollar on 21/11/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//

import Foundation
import UIkit

// Protocolo a implementar por la clase que delegue esta
protocol WebServiceProtocolo {
    // funcion que implementará la clase delegada y que recibirá los datos de repuesta a la llamada
    func didReceiveResponse_listadoVendedores(respuesta : [String : AnyObject])
    func didReceiveResponse_entradaBDD_ventaBarca(respuesta : [String : AnyObject])
    func didReceiveResponse_listadoVentas(respuesta : [String : AnyObject])
    
}

// PRUEBA DE CONEXIÓN CON WEBSERVICE A TRAVES DE AFNETWORKING
class webServiceCallAPI : NSObject {
    
    var delegate : WebServiceProtocolo?
    
    let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()

    var responseObject : AnyObject?
    
    // Esta llamada devuelve una lista con los vendedores del sistema
    func obtenerVendedores()  {
        var jsonDict : NSDictionary!
        var jsonArray : NSArray!
        var error : NSError?
        manager.GET(
            "http://losbarkitos.herokuapp.com/vendedores/",
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                println("responseObject: \(responseObject.description)")
                var indice : Int = 1
                var diccionario = [String : AnyObject]()
                for (k,v) in responseObject as [String : AnyObject] {
                    if k != "error" {
                        diccionario[k] = v
                    } else if v as NSString == "si" {// la respuesta es erronea
                        println("HAY UN ERROR QUE VIENE DEL SERVIDOR")
                        diccionario = [String : AnyObject]()
                        diccionario["error"] = "si"
                    }// hay un error y hay que paralo
                }
                println("diccionario: \(diccionario)")
                self.delegate?.didReceiveResponse_listadoVendedores(diccionario)// as NSDictionary)
            },
            
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
                println("Error: \(error.localizedDescription)")
                var diccionario = [String : AnyObject]()
                diccionario["error"] = "si"
                self.delegate?.didReceiveResponse_listadoVendedores(diccionario as Dictionary)// as NSDictionary)
            }
        )
        
    }
    
    func obtenerVentas() {
        var jsonDict :  NSDictionary!
        var jsonArray : NSArray!
        var error :     NSError?
        manager.GET("http://losbarkitos.herokuapp.com/listado_viaje/0/0/0",
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                var indice : Int = 1
                var diccionario = [String : AnyObject]()
                for (k,v) in responseObject as [String : AnyObject] {
                    if k != "error" {
                        diccionario[k] = v
                    } else if v as NSString == "si" { // la respuesta es errónea
                        println("HAY UN ERROR QUE VIENE DEL SERVIDOR")
                        diccionario = [String : AnyObject]()
                        diccionario["error"] = "si"
                    }
                }
                println("diccionario : \(diccionario)")
                self.delegate?.didReceiveResponse_listadoVentas(diccionario as Dictionary)
            },
            
            failure: {(operation: AFHTTPRequestOperation!, error : NSError!) in
                println("Error \(error.localizedDescription)")
                var diccionario = [String : AnyObject]()
                diccionario["error"] = "si"
                self.delegate?.didReceiveResponse_listadoVentas(diccionario as Dictionary)
            }
        )
    }
    
    func entradaBDD_ventaBarca(tipo : Int, precio : Int, puntoVenta : Int, vendedor : Int) {
        var jsonDict : NSDictionary!
        var jsonArray : NSArray!
        var error : NSError?
        manager.GET(
            "http://losbarkitos.herokuapp.com/registro_barca/\(tipo)/\(precio)/\(puntoVenta)/\(vendedor)/", parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                var diccionario = [String : AnyObject]()
                for (k,v) in responseObject as [String : AnyObject] {
                    if k != "error" {
                        diccionario[k] = v
                    } else if v as Int == 1 {// la respuesta es erronea
                        println("HAY UN ERROR QUE VIENE DEL SERVIDOR")
                        diccionario = [String : AnyObject]()
                        diccionario["error"] = "si"
                    }
                }
                println("diccionario : \(diccionario)")
                self.delegate?.didReceiveResponse_entradaBDD_ventaBarca(diccionario as Dictionary)
            },
            failure: {(operation: AFHTTPRequestOperation!, error : NSError!) in
                println("Error \(error.localizedDescription)")
                var diccionario = [String : AnyObject]()
                diccionario["error"] = "si"
                self.delegate?.didReceiveResponse_entradaBDD_ventaBarca(diccionario as Dictionary)
            }
        )
    }
}

