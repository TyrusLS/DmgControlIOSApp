//
//  LoginData.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 02.03.22.
//


import UIKit

let LoadUserData = loadUserData()
let LoadorgaData = loadOrgaData()
let LoaddeviceData = loadDeviceData()
let LoadequipmentData = loadEquipmentData()
let LoadheightData = loadHeightData()
let LoadfunctionData = loadFunctionData()

func loadUserData() -> [UserObj] {
    guard let file = Bundle.main.url(forResource: "loginData", withExtension: "json")else{
        
        fatalError("error")
    }
    return try!
    JSONDecoder().decode([UserObj].self, from: Data(contentsOf: file))
   
}

func loadOrgaData() -> [Organisations] {
    guard let file = Bundle.main.url(forResource: "orgaData", withExtension: "json")else{
        
        fatalError("error")
    }
    return try!
    JSONDecoder().decode([Organisations].self, from: Data(contentsOf: file))
   
}

func loadDeviceData() -> [DeviceObj] {
    guard let file = Bundle.main.url(forResource: "deviceData", withExtension: "json")else{
        
        fatalError("error")
    }
    return try!
    JSONDecoder().decode([DeviceObj].self, from: Data(contentsOf: file))
   
}
func loadEquipmentData() -> [EquipmentObj] {
    guard let file = Bundle.main.url(forResource: "equipData", withExtension: "json")else{
        
        fatalError("error")
    }
    return try!
    JSONDecoder().decode([EquipmentObj].self, from: Data(contentsOf: file))
   
}
func loadHeightData() -> [HeightObj] {
    guard let file = Bundle.main.url(forResource: "heightData", withExtension: "json")else{
        
        fatalError("error")
    }
    return try!
    JSONDecoder().decode([HeightObj].self, from: Data(contentsOf: file))
   
}
func loadFunctionData() -> [FunctionObj] {
    guard let file = Bundle.main.url(forResource: "damageData", withExtension: "json")else{
        
        fatalError("error")
    }
    return try!
    JSONDecoder().decode([FunctionObj].self, from: Data(contentsOf: file))
   
}
