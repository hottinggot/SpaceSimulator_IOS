//
//  Board.swift
//  GProject
//
//  Created by 서정 on 2021/07/15.
//

import Foundation
import SwiftyJSON


struct ProjectData: Codable {
    var fileDownloadUri: String
    var fileName: String
    var fileType: String
    var imageFileId: Int
    var size: CLong
}

struct ProjectRequestData: Codable {
    var projectId: Int
    var projectName: String
}

struct ProjectResultData: Codable {
    var name: String
    var createdTime: String
}


struct ProjectListObjectData: Codable {
    var projectId: Int
    var name: String
    var date: String
    var imageFileUri: String
    var imageFileId: Int
    
}
struct ImageListData : Codable {
    var imageFileId : Int
    var url : String
}

struct CheckProjectData : Codable {
    var isModelExist: Bool
    var model: Model?
}

struct CreateProjectData : Codable {
    var isModelExist: Bool
    var name: String
    var createdTime: String
    var model: String?
    var projectId: CLong
}

struct Model: Codable {
    
}

struct CoordinateModel {
    var coordinates : [([Int],[Int])] = []
    var width : Int
    var height : Int
    
    
    init(data : [([Int], [Int])], width : Int, height : Int){
        self.coordinates = data
        self.width = width
        self.height = height 
    }
    
//    init(data : [[[Int]]]) {
//
//        data.forEach { coordArray in
//            var temp : [[Int]] = coordArray
//            if let first = coordArray.first {
//                temp.append(first)
//            }
//            for index in 0...temp.count - 1 {
//                if index != temp.count - 1 {
//                    coordinates.append((temp[index], temp[index + 1]))
//                }
//            }
//
//        }
//    }
    
//
//    init(data : Data) {
//        do{
//            var jsonString = String(decoding: data, as: UTF8.self)
//            jsonString = String(jsonString.dropFirst().dropLast())
//            let keyCount = Int(jsonString.components(separatedBy: ":").count - 1)
//            print("keyCount",keyCount)
//            var temp : [([Int],[Int])] = []
//            for index in 0...(keyCount - 1) {
//                var jsonObject = try JSON(data: data)["\(index)"].arrayObject as? [[Int]] ?? []
//                var innerTemp : [([Int],[Int])] = []
//                if let first = jsonObject.first {
//                    jsonObject.append(first)
//                }
//                for index in 0...jsonObject.count - 1 {
//                    if index != jsonObject.count - 1 {
//                        innerTemp.append((jsonObject[index], jsonObject[index + 1]))
//                    }
//                }
//                temp.append(contentsOf: innerTemp)
//            }
//            coordinates = temp
//        }
//        catch(let error) {
//            print("error on coordinates model")
//            print(error)
//        }
//
//
//    }
}


struct FurniturePostModel {
    var name : String
    var x : Double
    var y : Double
}
