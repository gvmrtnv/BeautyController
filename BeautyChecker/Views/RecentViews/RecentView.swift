//
//  RecentView.swift
//  BeautyChecker
//
//  Created by Gleb Martynov on 01.05.22.
//

import SwiftUI

struct RecentView: View {
    @EnvironmentObject var vm: RecentViewModel
   
    var body: some View {
        NavigationView {
            VStack{
                imageScroll
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(Color.mildPink)
                    
                  
                    BeautygradeCardView(image: $vm.image, text: $vm.imageName, textVisible: $vm.textVisible)
                  
                }

            }
            .padding([.horizontal, .bottom])
            .task {
                if FileManager().docExist(named: fileName) {
                    vm.loadMyImagesJSONFile()
                }
            }
            .navigationTitle("Recent checks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if vm.image != nil {
                        Menu {
                            Button  {
                                let image = createBeautyCard()
                                vm.share(card: image)
                            } label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                            
                            Button  {
                                
                                let image = createBeautyCard()
                                vm.saveBeautyGradeCard(image: image)
                            } label: {
                                Label("Save to gallery", systemImage: "square.and.arrow.down")
                            }
                            
                            Button  {
                                vm.deleteSelected()
                            } label: {
                                Label("Delete", systemImage: "minus.circle")
                            }
                            
                            

                        } label: {
                            Label("", systemImage: "ellipsis.circle")
                        }
                    }
                        
                }
                
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
    
    func createBeautyCard() -> UIImage {
        let imageSize: CGSize = CGSize(width: 1000, height: 1000)
        let image = BeautygradeCardView(image: $vm.image, text: $vm.imageName, textVisible: $vm.textVisible).ignoresSafeArea().asImage(size: imageSize)
        return image
        
    }
    
}

struct RecentView_Previews: PreviewProvider {
    static var previews: some View {
        RecentView()
            .environmentObject(RecentViewModel())
    }
}
