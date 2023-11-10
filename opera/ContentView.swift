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
    
    @State var searchRequest = MusicCatalogSearchRequest(
        term: "Hello",
        types: [
            Artist.self,
            Album.self,
            Song.self
        ]
    )


    var body: some View {
        NavigationView {
           
        }
    }
    
    
    private let request: MusicLibrarySearchRequest = {
        var request = MusicLibrarySearchRequest(term: "Happy", types: [Song.self])
        request.limit = 25
        return request
    }()

    // Loading catalog search top results
    private func fetchMusic() {
        Task {
            // Request permission
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                do {
                    // Request -> Response
                    searchRequest.includeTopResults = true
                    let searchResponse = try await searchRequest.response()
                    print("\(searchResponse.topResults)")

                    
                    
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

