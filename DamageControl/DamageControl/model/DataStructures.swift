//
//  UserObj.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 02.03.22.
//

import Foundation

struct UserObj: Decodable{
    public let username: String
    public let password: String
}
struct Organisations: Decodable {
    public let organisation: String
}

struct DeviceObj: Decodable{
    public let deviceID: String
}
struct EquipmentObj: Decodable{
    public let id: String
    public let equipname: String
}
struct HeightObj: Decodable{
    public let height: String
}
struct FunctionObj: Decodable{
    public let function: String
}

