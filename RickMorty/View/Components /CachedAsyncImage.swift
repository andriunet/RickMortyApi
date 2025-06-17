//
//  CachedAsyncImage.swift
//  RickMorty
//
//  Created by Andres on 17/06/25.
//


import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    let placeholder: () -> AnyView
    let image: (Image) -> AnyView

    init(url: URL?,
         @ViewBuilder placeholder: @escaping () -> AnyView,
         @ViewBuilder image: @escaping (Image) -> AnyView) {
        self.url = url
        self.placeholder = placeholder
        self.image = image
    }

    @State private var loadedImage: UIImage?

    var body: some View {
        if let loadedImage = loadedImage {
            image(Image(uiImage: loadedImage))
        } else {
            placeholder()
                .task {
                    await loadImage()
                }
        }
    }

    private func loadImage() async {
        guard let url = url else { return }

        if let cached = ImageCache.shared.object(forKey: url as NSURL) {
            self.loadedImage = cached
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                ImageCache.shared.setObject(uiImage, forKey: url as NSURL)
                self.loadedImage = uiImage
            }
        } catch {
            print("Image download error: \(error.localizedDescription)")
        }
    }
}


class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
}
