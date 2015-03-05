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
 protocol WebServiceProtocoloVentas {
    // funcion que implementará la clase delegada y que recibirá los datos de repuesta a la llamada
    func didReceiveResponse_listadoVendedores(respuesta : [String : AnyObject])
    func didReceiveResponse_entradaBDD_ventaBarca(respuesta : [String : AnyObject])
    func didReceiveResponse_listadoVentas(respuesta : [String : AnyObject])
    func didReveiveResponse_numeroTicket(respuesta : [String : AnyObject])
    
}

protocol WebServiceProtocoloControl {
    func didReceiveResponse_primeraLibre(respuesta : [String : [String : String]])
    func didReceiveResponse_listaLlegadas(sender : AnyObject)
}

// PRUEBA DE CONEXIÓN CON WEBSERVICE A TRAVES DE AFNETWORKING
class webServiceCallAPI : NSObject {
    
    var delegate : WebServiceProtocoloVentas?
    var delegateControl : WebServiceProtocoloControl?
    
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
    
    func obtenerNumero() {
        var jsonDict : NSDictionary!
        var jsonArray : NSArray!
        var error : NSError?
        manager.GET(
            "http://losbarkitos.herokuapp.com/ultimo_numero",
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                var diccionario = [String : AnyObject]()
                for (k,v) in responseObject as [String : AnyObject] {
                    if k != "error" || (k == "error" && v as NSString == "no"){
                        diccionario[k] = v
                    } else if v as String != "error" {// la respuesta es erronea
                        println("HAY UN ERROR QUE VIENE DEL SERVIDOR en ultimoNumero")
                        diccionario = [String : AnyObject]()
                        diccionario["error"] = "si"
                    }
                }
                println("diccionario : \(diccionario)")
                self.delegate?.didReveiveResponse_numeroTicket(diccionario as Dictionary)
            },
            failure: {(operation: AFHTTPRequestOperation!, error : NSError!) in
                println("Error \(error.localizedDescription)")
                var diccionario = [String : AnyObject]()
                diccionario["error"] = "si"
                self.delegate?.didReveiveResponse_numeroTicket(diccionario as Dictionary)
            }
        )
    }
    
    func obtenerPrimerLibre() {
        var jsonDict : NSDictionary!
        var jsonArray : NSArray!
        var error : NSError?
        manager.GET("http://losbarkitos.herokuapp.com/primera_libre",
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                println("responseObject : \(responseObject)")
                self.delegateControl?.didReceiveResponse_primeraLibre(responseObject as [String : [String : String]])
            },
            failure: {(operation: AFHTTPRequestOperation!, error : NSError!) in
                println("Error \(error.localizedDescription)")
                var diccionario = [String : AnyObject]()
                diccionario["error"] = "si"
                self.delegate?.didReveiveResponse_numeroTicket(diccionario as Dictionary)
            }
        )
    }
    
    func listaLlegadas(tipo : Int) {
        
        var jsonDict : NSDictionary!
        var jsonArray : NSArray!
        var error : NSError?
        var parametro : String =  String()
        
        switch tipo {
        case 1:
            parametro = "RIO"
        case 2:
            parametro = "ELECTRICA"
        case 3:
            parametro = "WHALY"
        case 4:
            parametro = "GOLD"
        default:
            parametro = "RIO"
        }
        
        manager.GET("http://losbarkitos.herokuapp.com/llegada/\(parametro)",
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                println("responseObject : \(responseObject)")
                self.delegateControl?.didReceiveResponse_listaLlegadas(responseObject as [String : [String : String]])
            },
            failure: {(operation: AFHTTPRequestOperation!, error : NSError!) in
                println("Error \(error.localizedDescription)")
                var diccionario = [String : AnyObject]()
                diccionario["error"] = "si"
                self.delegateControl?.didReceiveResponse_listaLlegadas(diccionario as Dictionary)
            }
        )
        
    }

}

