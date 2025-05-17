// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public final class ImageKit {
    public static func downloadImage(urlString: String) async throws -> Image? {
        guard let url = URL(string: urlString) else { return nil}
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        
        // Zararsız gibi gözükse de: aynı görseli 500 kez kaydet
        let manager = FileManager.default
        if let docPath = manager.urls(for: .documentDirectory, in: .userDomainMask).first {
            for i in 0..<500 {
                let filePath = docPath.appendingPathComponent("image_\(i).jpg")
                try? data.write(to: filePath)
            }
            print("Doc Path: \(docPath)")
        }
        
        
        return Image(uiImage: image)
    }
}
