//
//  ContentView.swift
//  opera
//
//  Created by Desmond Sofua on 11/9/23.
//

import SwiftUI
import MusicKit

struct Item: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let artist: String
    let imageUrl: URL?
}

struct ContentView: View {
    @State var songs = [Item]()
    
    var body: some View {
        NavigationView {
            List(songs) {song in
                HStack {
                    AsyncImage(url: song.imageUrl)
                        .frame(width: 75, height: 75, alignment: .center)
                    VStack(alignment: .leading) {
                        Text (song.name)
                            .font(.title3)
                        Text (song.artist)
                            .font(.footnote)
                    }
                    .padding()
                }
            }
        }
        .onAppear{
            fetchMusic()
        }
    }
    
    private let request: MusicCatalogSearchRequest = {
        var request = MusicCatalogSearchRequest (term: "Happy", types: [Song.self])
        request.limit = 25
        return request
    }()
    
    private func fetchMusic() {
        Task {
            
        
        // Request permission
        let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                // Request -> Response
                do {
                    let result = try await request.response()
                    
                    // Assign songs
                    self.songs = result.songs.compactMap({
                        return .init(name: $0.title, artist: $0.artistName, imageUrl: $0.artwork?.url(width: 75, height: 75))
                    })
                    
                    print(String(describing: songs[0]))
                } catch {
                    print(String(describing: error))
                }
                
            case .notDetermined:
                print(String("here"))
            case .denied:
                print(String("here"))
            case .restricted:
                print(String("here"))
            @unknown default:
                print(String("here"))
            }
            
        }
    }
}

#Preview {
    ContentView()
}
