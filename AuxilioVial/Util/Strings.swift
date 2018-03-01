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
    let MENSAJE_REGISTRO_EXITOSO = "Registro exitoso, el administrador validará su información y le enviará un correo electrónico cuando active su cuenta."
    let MENSAJE_REGISTRO_FALLIDO: String = "Intentelo más tarde"
    
    let MENSAJE_TRAMO: String = "Seleccione el tramo"
    let MENSAJE_DESCRIPCION: String = "Ingrese una descripción"
    let MENSAJE_KM_INICIO: String = "Ingrese un Km. Inicial"
    let MENSAJE_KM_FINAL: String = "Ingrese un Km. Final"
    let MENSAJE_FUENTE_INFO: String = "Ingrese una fuente de información"
    let MENSAJE_LESIONADOS: String = "Ingrese el número de lesionados"
    let MENSAJE_MUERTOS: String = "Ingrese el número de muertos"
    let MENSAJE_VEHICULO: String = "Ingrese el vehículo"
    let MENSAJE_VEHICULOS_INVOLUCRADOS: String = "Ingrese los vehículos involucrados"
    let MENSAJE_DANIO_CAMINO: String = "Ingrese los daños al camino"
    let MENSAJE_RESIDENTE_VIAL: String = "Ingrese el Residente Vial"
    let MENSAJE_TIEMPO_RESPUESTA: String = "Ingrese el tiempo de respuesta"
    let MENSAJE_OBSERVACION: String = "Ingrese las observaciones"
    
    let TITULO_REGISTRO_EXITOSO: String = "Registro exitoso"
    let TITULO_REGISTRO_FALLIDO: String = "Ocurrio un error"
    let TITULO_ADVERTENCIA: String = "Advertencia"
    let TITULO_POR_FAVOR: String = "Por favor"
    let TITULO_ERROR_VALIDACION: String = "Error de validación"
    let MSG_ERROR_REGISTRO: String = "Registro exitoso, el administrador validará su información y le enviará un correo electrónico cuando active su cuenta."
    let MENSAJE_SIN_INTERNET: String = "Conectese a internet para poder realizar la operación."
    let MSG_EXITO_REGISTRO: String = "Registro exitoso, el administrador validará su información y le enviará un correo electrónico cuando active su cuenta."
    
    let servidor: String = "http://187.188.120.156"
    let puerto: String = ":80"
    let contexto: String = "/AUVI"
    
    
    let SERVICE_POST_ACCESO: String = "/service/valid/access"//correo, contrasenia
    let servicioRegistro: String = "/service/valid/registro"
    
    let SERVICE_GET_CLASE: String = "/service/catalog/clase"
    let SERVICE_GET_CUERPO: String = "/service/catalog/cuerpo"
    let SERVICE_GET_ENTIDADFEDERATIVA: String = "/service/catalog/entidad"
    let SERVICE_GET_LADO: String = "/service/catalog/lado"
    let SERVICE_GET_ORIENVISIB: String = "/service/catalog/orienVisib"
    
    
    let SERVICE_POST_CARRETERA: String = "/service/catalog/carretera" //identidad
    let SERVICE_POST_REGISTRO: String = "service/valid/registro"
    let SERVICE_POST_SUBTIPO: String = "/service/catalog/subTipo" //idclase
    let SERVICE_POST_TIPO: String = "/service/catalog/tipo" //idclase
    let SERVICE_POST_TIPO_ESPECIFICO: String = "/service/catalog/tipoEsp" //idtipo
    let SERVICE_POST_TRAMO: String = "/service/catalog/tramo" //idcarretera
    
    
    
    
}
