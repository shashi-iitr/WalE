//
//  ContentView.swift
//  WalE
//
//  Created by Shashi on 23/03/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = AstronomyDataModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .leading, spacing: 16) {
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
                    viewModel.loadPictureOfDay { astronomyPicture in
                        if let astronomyPicture = astronomyPicture {
                            viewModel.astronomyPicture = astronomyPicture
                        }
                    }
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
