//
//  ContentView.swift
//  WalE
//
//  Created by Shashi on 23/03/23.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    @StateObject private var viewModel = AstronomyDataModel()
    @State var player = AVPlayer()
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack (spacing: 12) {
                    Spacer()
                    
                    Image(systemName: "wifi.exclamationmark")
                    Text("No internet connection")
                        .foregroundColor(Color(UIColor.label))
//                        .padding()
                    Spacer()
                }
                .frame(minHeight: viewModel.connected ? 0 : 56)
                .background(Color.primary.opacity(0.2))
                .opacity(viewModel.connected ? 0 : 1)
                .animation(.easeOut, value: viewModel.connected)
                
                VStack (alignment: .leading, spacing: 16) {
                    if viewModel.astronomyPicture.mediaType == "image" {
                        if let url = URL.init(string: viewModel.astronomyPicture.url) {
                            AsyncImage(
                                url: url,
                                content: { image in
                                    GeometryReader { geometry in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .ignoresSafeArea()
                                        //                                    .edgesIgnoringSafeArea(.all)
                                            .frame(maxWidth: geometry.size.width,
                                                   maxHeight: geometry.size.height)
                                    }
                                },
                                placeholder: {
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                        Spacer()
                                    }
                                }
                            )
                            .frame(height: 400)
                        }
                    } else if viewModel.astronomyPicture.mediaType == "video" {
                        if let url = URL.init(string: viewModel.astronomyPicture.url) {
                            VideoPlayer(player: player)
                                .onAppear() {
                                    player = AVPlayer(url: url)
                                }
                                .frame(height: 400)
                        }
                    }
                    
                    Text(viewModel.astronomyPicture.title)
                        .font(.title3)
                    
                    Text(viewModel.astronomyPicture.explanation)
                        .font(.body)
                        .lineSpacing(4)
                        .foregroundColor(Color.gray)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .onAppear {
                    viewModel.loadPictureOfDay()
                }
            }
            .navigationTitle("Picture of the day")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
