//
//  FilePilot.swift
//  EvaluationManager
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 15/02/2024.
//  Copyright © 2024 Proagrica-AH. All rights reserved.
//

import Foundation
//import UIKit

class FilePilot {
    
    enum OSPath {
        case documents([String])
        case caches([String])
        
        static func documents() -> OSPath {
            return .documents([])
        }
        
        static func caches() -> OSPath {
            return .caches([])
        }
        
        
        func add(_ folderName: String) -> OSPath {
            var folders: [String]
            switch self {
            case .documents(let existingFolders):
                folders = existingFolders
            case .caches(let existingFolders):
                folders = existingFolders
            }
            folders.append(folderName)
            switch self {
            case .documents:
                return .documents(folders)
            case .caches:
                return .caches(folders)
            }
        }
        
        var directory: FileManager.SearchPathDirectory {
            switch self {
            case .documents:
                return .documentDirectory
            case .caches:
                return .cachesDirectory
                
            }
        }
        
        var path: String {
            switch self {
            case .documents(let folders):
                return folderPath(for: .documentDirectory, folders: folders)
            case .caches(let folders):
                return folderPath(for: .cachesDirectory, folders: folders)
                
            }
        }
        
        var url: URL? {
            switch self {
            case .documents(let folders):
                return folderURL(for: .documentDirectory, folders: folders)
            case .caches(let folders):
                return folderURL(for: .cachesDirectory, folders: folders)
                
            }
        }
        
        private func folderPath(for directory: FileManager.SearchPathDirectory, folders: [String]) -> String {
            var path = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first ?? ""
            for folder in folders {
                path += "/\(folder)"
            }
            return path
        }
        
        private func folderURL(for directory: FileManager.SearchPathDirectory, folders: [String]) -> URL? {
            guard var url = FileManager.default.urls(for: directory, in: .userDomainMask).first else { return nil }
            for folder in folders {
                url.appendPathComponent(folder)
            }
            return url
        }
    }
    
    
    
//    func saveFile(fileName: String, image: UIImage, to path: OSPath, _ completion: @escaping ClosureResult<URL>) {
//        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
//            let error = CustomError.message(0, "Failed to convert UIImage to Data")
//            completion(.failure(error))
//            return
//        }
//        
//        // Call the existing saveFile function for saving data
//        saveFile(fileName: fileName, data: imageData, to: path, completion)
//    }
    
    func saveFile(fileName: String, content: String, to path: OSPath, _ completion: @escaping ClosureResult<URL>) {
        guard let data = content.data(using: .utf8) else {
            let error = CustomError.message(0, "Failed to convert string content to data")
            completion(.failure(error))
            return
        }
        
        saveFile(fileName: fileName, data: data, to: path, completion)
    }
    
    func saveFile(fileName: String, data: Data, to path: OSPath, _ completion: @escaping ClosureResult<URL>) {
        guard let folderURL = path.url else {
            completion(.failure(CustomError.message(0, "Failed to access OS path")))
            return
        }
        
        let fileURL = folderURL.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            completion(.success(fileURL))
        } catch {
            completion(.failure(error))
        }
    }
    
    func loadFile(from path: OSPath, fileName: String, _ completion: @escaping ClosureResult<Data>) {
        guard let folderURL = path.url else {
            completion(.failure(CustomError.message(0, "Failed to access OS path")))
            return
        }
        
        let fileURL = folderURL.appendingPathComponent(fileName)
        
        do {
            let data = try Data(contentsOf: fileURL)
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteFile(from path: OSPath, fileName: String, _ completion: @escaping ClosureResult<Void>) {
        guard let folderURL = path.url else {
            let error = CustomError.message(0, "Failed to access OS path")
            completion(.failure(error))
            return
        }
        
        let fileURL = folderURL.appendingPathComponent(fileName)
        
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: fileURL)
            completion(.success(()))
        } catch {
            let error = CustomError.message(0, "Failed to delete file: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func createFolder(path: OSPath, _ completion: @escaping ClosureResult<Void>) {
        let fileManager = FileManager.default
        
        // Get the URL of the specified directory
        guard let folderURL = path.url else {
            let error = CustomError.message(0, "Failed to access OS path")
            completion(.failure(error))
            return
        }
        
        var isDir: ObjCBool = true // inItialize to true for checking directory existence
        // Check if the folder already exists and if it's a directory
        if fileManager.fileExists(atPath: folderURL.path, isDirectory: &isDir) {
            if isDir.boolValue {
                // Folder already exists, call the completion handler with success
                completion(.success(()))
                return
            }
            // Path exists but it's not a directory, handle accordingly
            let error = CustomError.message(0, "Path already exists but is not a directory")
            completion(.failure(error))
            return
        }
        
        // Folder doesn't exist, create it
        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            completion(.success(()))
        } catch {
            let error = CustomError.message(0, "Failed to create folder: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    func createFolder(path: OSPath) {
        let fileManager = FileManager.default
        
        // Get the URL of the specified directory
        guard let folderURL = path.url else {
            // Handle error
            return
        }
        
        var isDir: ObjCBool = true // inItialize to true for checking directory existence
        
        // Check if the folder already exists and if it's a directory
        if fileManager.fileExists(atPath: folderURL.path, isDirectory: &isDir) {
            if isDir.boolValue {
                // Folder already exists, return
                return
            }
            // Path exists but it's not a directory, handle accordingly
            return
        }
        
        // Folder doesn't exist, create it
        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            // Handle error
        }
    }

    func deleteFolder(path: OSPath, _ completion: @escaping ClosureResult<Void>) {
        let fileManager = FileManager.default
        
        // Get the URL of the specified directory
        guard let folderURL = path.url else {
            let error = CustomError.message(0, "Failed to access OS path")
            completion(.failure(error))
            return
        }
        
        var isDir: ObjCBool = true // Initialize to true for checking directory existence
        // Check if the folder exists and if it's a directory
        if !fileManager.fileExists(atPath: folderURL.path, isDirectory: &isDir) || !isDir.boolValue {
            // Folder doesn't exist or it's not a directory, call the completion handler with success
            completion(.success(()))
            return
        }
        
        // Delete the folder
        do {
            try fileManager.removeItem(at: folderURL)
            completion(.success(()))
        } catch {
            let error = CustomError.message(0, "Failed to delete folder: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    
}









