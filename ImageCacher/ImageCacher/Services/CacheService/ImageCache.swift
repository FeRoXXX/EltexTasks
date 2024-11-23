//
//  ImageCache.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 21.11.2024.
//

import UIKit

final class ImageCache {
    
    //MARK: - Singleton request
    
    static let shared = ImageCache()
    
    //MARK: - Private properties
    
    private let cache = NSCache<NSString, ImageCacheObject>()
    private let lock = NSLock()
    private let folderName = "cachedImages"
    
    //MARK: - initialization
    
    private init() {}
    
    //MARK: - Create folder function
    
    private func createFolderIfNeeded() {
        guard let url = getCacheFolderPath() else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Get cache path function
    
    private func getCacheFolderPath() -> URL? {
        FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }

    //MARK: - Create image path
    
    private func getImagePath(key: String) -> URL? {
        guard let folder = getCacheFolderPath() else {
            return nil
        }
        
        return folder.appendingPathComponent(key)
    }

    //MARK: - Add to cache function
    
    func add(key: String, value: ImageCacheObject, typeOfCache: DownloadOptions.From) {
        lock.lock(); defer { lock.unlock() }
        switch typeOfCache {
        case .disk:
            createFolderIfNeeded()
            saveObject(value, forKey: key)
        case .memory:
            cache.setObject(value, forKey: key as NSString)
        }
    }

    //MARK: - Get cache for key
    
    func get(key: String) -> ImageCacheObject? {
        lock.lock(); defer { lock.unlock() }
        if let object = loadObject(forKey: key) {
            return object
        } else if let object = cache.object(forKey: key as NSString) {
            return object
        } else {
            return nil
        }
    }
    
    //MARK: - Save object to disk cache
    
    private func saveObject(_ object: ImageCacheObject, forKey key: String) {
        guard let url = getImagePath(key: key) else { return }
        
        do {
            let directory = url.deletingLastPathComponent()
            if !FileManager.default.fileExists(atPath: directory.path) {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            }
            
            let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
            
            try data.write(to: url)
        } catch {
            print("Ошибка сохранения объекта: \(error)")
        }
    }
    
    //MARK: - load object from disk cache
    
    private func loadObject(forKey key: String) -> ImageCacheObject? {
        guard let url = getImagePath(key: key), FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            if let object = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSData.self, ImageCacheObject.self], from: data) as? ImageCacheObject {
                return object
            }
        } catch {
            print("Failed to load object: \(error)")
        }
        return nil
    }
}
