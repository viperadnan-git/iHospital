//
//  FileManager.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 15/07/24.
//

import Foundation

extension FileManager {
    /// Saves data to the temporary directory with the specified file name
    /// - Parameters:
    ///   - fileName: The name of the file to be saved
    ///   - data: The data to be written to the file
    /// - Throws: An error if the data could not be written
    /// - Returns: The URL of the saved file
    static func saveToTempDirectory(fileName: String, data: Data) throws -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        try data.write(to: fileURL)
        
        return fileURL
    }
    
    /// Checks if a file exists in the temporary directory with the specified file name
    /// - Parameter fileName: The name of the file to check
    /// - Returns: The URL of the file if it exists, otherwise nil
    static func tempFileExists(fileName: String) -> URL? {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        return FileManager.default.fileExists(atPath: fileURL.path) ? fileURL : nil
    }
}

