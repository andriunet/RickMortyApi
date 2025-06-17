//
//  CharacterListView.swift
//  RickMorty
//
//  Created by Andres on 16/06/25.
//
import SwiftUI

struct CharacterListView: View {
    @StateObject private var viewModel = CharactersViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.characters) { character in
                        NavigationLink(destination: CharacterDetailView(character: character)) {
                            HStack {
                                CachedAsyncImage(
                                    url: URL(string: character.image),
                                    placeholder: {
                                        AnyView(
                                            ProgressView()
                                                .frame(width: 80, height: 80)
                                                .background(Color.gray.opacity(0.2))
                                                .clipShape(Circle())
                                                .scaleEffect(0.7)
                                                .animation(.easeInOut, value: 1)
                                        )
                                    },
                                    image: { image in
                                        AnyView(
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 80, height: 80)
                                                .clipShape(Circle())
                                                .transition(.asymmetric(insertion: .move(edge: .top), removal: .opacity))
                                        )
                                    }
                                )
                                .accessibilityLabel("Imagen del personaje \(character.name)")
                                
                                VStack(alignment: .leading) {
                                    Text(character.name)
                                        .font(.headline)
                                    Text(character.status)
                                        .font(.subheadline)
                                    Text(character.species)
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
          
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        if viewModel.hasMorePages {
                            Button("Cargar más") {
                                viewModel.fetchCharacters()
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                .navigationTitle("Rick and Morty")
                .onAppear {
                    if viewModel.characters.isEmpty {
                        viewModel.fetchCharacters()
                    }
                }
                .refreshable {
                    viewModel.refreshCharacters()
                }
                
            }
        }
    }
}

#Preview {
    CharacterListView()
}
