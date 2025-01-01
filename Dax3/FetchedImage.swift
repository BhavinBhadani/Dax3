//
//  FetchedImage.swift
//  Dax3
//
//  Created by Bhavin Bhadani on 01/01/25.
//

import SwiftUI

struct FetchedImage: View {
    let url: URL?
    
    var body: some View {
        if let url, let imageData = try? Data(contentsOf: url) {
            
        }
    }
}

#Preview {
    FetchedImage(url: SamplePokemon.samplePokemon.sprite)
}
