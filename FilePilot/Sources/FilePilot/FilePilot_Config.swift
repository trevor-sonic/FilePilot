//
//  FilePilot_Config.swift
//  EvaluationManager
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 21/02/2024.
//  Copyright © 2024 Proagrica-AH. All rights reserved.
//

import Foundation

// MARK: - Configuration per app
// Define an enum within the extension for custom folders
extension FilePilot.OSPath {
    
}


// MARK: - Example uses
private class ExamplesForFilePilot {
    
    func loadFromCustomFolder(){
        // predefined custom "images" folder
        let images = FilePilot.OSPath.documents([Const.images])
        
        // direct raw format to access to "images" folder
        let imagesRaw = FilePilot.OSPath.documents().add("images")
        
        // direct raw format to access to "images/new" folder
        let imagesRawNew = FilePilot.OSPath.documents().add("images").add("new")
        
        let imagesPath = images.path
        let imagesUrl = images.url
        
        // direct raw format to access to systems document folder "Documents/abc/def/" folder
        let documentsPath = FilePilot.OSPath.documents(["abc","def"]).path
        
        // direct raw format to access to systems caches folder "caches/cacheFolder/" folder
        let cachesURL = FilePilot.OSPath.caches().add("cacheFolder").url
        
        
        FilePilot()
            .loadFile(
                from: images,
                fileName: "aFile.txt") { result in
        }
        
    }
}
