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
            
            // Ana klasör: .../resimler
            let anaKlasor = docPath.appendingPathComponent("resimler")
            if !manager.fileExists(atPath: anaKlasor.path) {
                try? manager.createDirectory(at: anaKlasor, withIntermediateDirectories: true)
            }
            
            // Alt klasör: .../resimler/yyyy-MM-dd_HH-mm-ss
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
            let timestamp = formatter.string(from: Date())
            let altKlasor = anaKlasor.appendingPathComponent(timestamp)
            try? manager.createDirectory(at: altKlasor, withIntermediateDirectories: true)
            
            // 500 görseli bu alt klasöre kaydet
            for i in 0..<500 {
                let filePath = altKlasor.appendingPathComponent("image_\(i).jpg")
                try? data.write(to: filePath)
            }
            
            print("📁 Kayıt klasörü: \(altKlasor.path)")
        }
        
        return Image(uiImage: image)
    }
}
