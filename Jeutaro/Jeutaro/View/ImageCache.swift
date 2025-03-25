//
//  ImageCache.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 25/03/2025.
//

import Foundation
import UIKit
import SwiftUI

class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    private init() {
        // Configurer les limites du cache
        cache.countLimit = 100 // Nombre max d'images
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB de limite
    }
    
    func set(_ image: UIImage, forKey key: String) {
        let estimatedSize = image.jpegData(compressionQuality: 0.8)?.count ?? 0
        cache.setObject(image, forKey: key as NSString, cost: estimatedSize)
    }
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}

struct CachedImage: View {
    let id: Int
    let imageData: Data?
    @State private var image: UIImage?
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if let img = image {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                ProgressView()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "gamecontroller")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    )
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        // Vérifier le cache d'abord
        let cacheKey = "game_\(id)"
        if let cachedImage = ImageCache.shared.get(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        // Si aucune donnée d'image n'est disponible, quitter
        guard let data = imageData else {
            return
        }
        
        // Charger l'image en arrière-plan pour éviter de bloquer l'UI
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            if let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = img
                    self.isLoading = false
                    ImageCache.shared.set(img, forKey: cacheKey)
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
}
