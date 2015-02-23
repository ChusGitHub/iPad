//
//  estadoClase.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 23/2/15.
//  Copyright (c) 2015 Jesus Valladolid Rebollar. All rights reserved.
//

import Foundation

class estado: NSObject {
    
    var nombreEstado : String?
    
    var horaLlegada : NSDate? // almacena la hora de la primera barca disponible
    
    var control : Int?
    
    // nombreEstado : INICIAL - No hay reservas ni barcas fuera
    //                INTERMEDIO - No hay reservas pero hay barcas fuera
    //                FINAL - Hay reservas
    
    func transicion(nombreEstado : String, control : Int, tipoTransicion : String) -> estado {
        
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "hh:mm:ss"
        self.control = control
        self.nombreEstado = nombreEstado
        
        if nombreEstado == "INICIAL" {
            if tipoTransicion == "SALIDA" {
                
                self.horaLlegada = NSDate().dateByAddingTimeInterval(3600) // se añade una hora a la hora de salida
                self.nombreEstado = "INTERMEDIO"
                self.control = 0
            }
        } else if nombreEstado == "INTERMEDIO" {
            if tipoTransicion == "LLEGADA" {
                self.horaLlegada = nil
                self.nombreEstado = "INICIAL"
                self.control = 0
            } else if tipoTransicion == "RESERVA" {
                self.horaLlegada = self.horaLlegada?.dateByAddingTimeInterval(3600) // se incrementa una hora
                self.nombreEstado = "FINAL"
                self.control? += 1
            }
        } else if nombreEstado == "FINAL" {
            if tipoTransicion == "SALIDA" {
                if self.control > 0 {
                    self.control? -= 1
                } else if self.control == 1 {
                    self.nombreEstado = "INTERMEDIO"
                    self.control = 0
                }
                if tipoTransicion == "RESERVA" {
                    self.control? += 1
                    self.horaLlegada = self.horaLlegada?.dateByAddingTimeInterval(3600) // se incrementa una hora
                }
            }
        }
        return self
    }
}