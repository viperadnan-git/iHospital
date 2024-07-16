//
//  FileManager.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 15/07/24.
//

import Foundation

extension FileManager {
    static func saveToTempDirectory(fileName: String, data: Data) throws -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        try data.write(to: fileURL)
        
        return fileURL
    }
    
    static func tempFileExists(fileName: String) -> URL? {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return fileURL
        }
        
        return nil
    }
}
