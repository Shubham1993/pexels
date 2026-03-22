//
//  FastAsyncImage.swift
//  Pexels
//
//  Created by shubham gupta on 23/03/26.
//

import SwiftUI

struct FastAsyncImage: View {
    let url: URL?

    var body: some View {
        AsyncImage(url: url, transaction: Transaction(animation: nil)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()

            case .failure(_), .empty:
                Color.gray.opacity(0.2)

            @unknown default:
                Color.gray.opacity(0.2)
            }
        }
    }
}
