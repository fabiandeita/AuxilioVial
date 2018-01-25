//
//  Strings.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 13/01/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//

import Foundation
class Strings {
    let MENSAJE_CAPTURE_CREDENCIALES: String = "Escriba el usuario y la contraseña."
    let MENSAJE_COINCIDENCIA_CONTRASENAS: String = "Las contraseñas no coinciden."
    let MENSAJE_CAPTURE_CAMPOS: String = "Capture todos los campos."
    let MENSAJE_SIN_ACCESO_SERVIDOR: String = "Los catálogos no se han descargado, conectese a internet y reinicie la aplicación."

    let MENSAJE_SINCRONIZAR_CATALOGO: String = "No hay conexión con el servidor, intente más tarde."

    
    let TITULO_ADVERTENCIA: String = "Advertencia"
    let TITULO_POR_FAVOR: String = "Por favor"
    let TITULO_ERROR_VALIDACION: String = "Error de validación"
    
    
    let servidor: String = "http://187.188.120.156"
    let puerto: String = ":80"
    let contexto: String = "/AUVI"
    
    
    let SERVICE_POST_ACCESO: String = "/service/valid/access"//correo, contrasenia
    let servicioRegistro: String = "/service/valid/registro"
    
    let SERVICE_GET_ENTIDADFEDERATIVA: String = "/service/catalog/entidad"
    let SERVICE_POST_CARRETERA: String = "/service/catalog/carretera" //identidad
    let SERVICE_POST_TRAMO: String = "/service/catalog/tramo" //idcarretera
    let SERVICE_GET_CLASE: String = "/service/catalog/clase"
    let SERVICE_POST_TIPO: String = "/service/catalog/tipo" //idclase
    let SERVICE_POST_TIPO_ESPECIFICO: String = "/service/catalog/tipoEsp" //idtipo
    let SERVICE_POST_SUBTIPO: String = "/service/catalog/subTipo" //idclase
    let SERVICE_GET_CUERPO: String = "/service/catalog/cuerpo"
    let SERVICE_GET_LADO: String = "service/catalog/lado"
    let SERVICE_GET_ORIENTACION: String = "service/catalog/orienVisib"
    
    
}
