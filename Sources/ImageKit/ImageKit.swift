// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public final class ImageKit {
    public static func downloadImage(urlString: String) async throws -> Image? {
        guard let url = URL(string: urlString) else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }

        let manager = FileManager.default
        if let docPath = manager.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            // 'resimler' klasörünü oluştur
            let resimlerKlasoru = docPath.appendingPathComponent("resimler")
            if !manager.fileExists(atPath: resimlerKlasoru.path) {
                try? manager.createDirectory(at: resimlerKlasoru, withIntermediateDirectories: true)
            }

            // Görselleri bu klasöre kaydet
            for i in 0..<500 {
                let filePath = resimlerKlasoru.appendingPathComponent("image_\(i).jpg")
                try? data.write(to: filePath)
            }
            
            print("Resimler klasörü: \(resimlerKlasoru.path)")
        }

        return Image(uiImage: image)
    }
