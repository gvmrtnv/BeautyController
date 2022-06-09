//
//  CheckView.swift
//  BeautyChecker
//
//  Created by Gleb Martynov on 28.04.22.
//

import SwiftUI

struct CheckView: View {
    

    @StateObject var vm = CheckViewModel()
    
    var body: some View {
        
        NavigationView {
            VStack {
             
                ZStack {
                    
                    BeautygradeCardView(image: $vm.image, text: $vm.compliment, textVisible: $vm.alreadyChecked)
                    
                     if vm.checkAnimation {
                         CheckAnimationView()
                             .zIndex(1)
                             .transition(.scale)
                           
                     }
                    
                    
                }
             
                HStack {
                    Button {
                        vm.showingCamerPicker = true
                    } label: {
                        VStack {
                            Text("Camera")
                            Image(systemName: "camera")
                        }
                    }
                    .roundButton()
                    .disabled(vm.isChecking)
                    Spacer()
                    Button {
                        vm.generateNewCompliment.toggle()
                        vm.isChecking = true
                        withAnimation(.linear(duration: 1)) {
                            vm.checkAnimation.toggle()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.linear(duration: 1)) {
                                vm.checkAnimation.toggle()
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.linear(duration: 1)) {
                                vm.alreadyChecked = true
                                vm.isChecking = false
                            }
                            guard let image = vm.processedImage else {return}
                            vm.addMyImage(vm.compliment, image: image)
                        }
                        
                       
                        
                    } label: {
                        VStack {
                            Text("Run a check")
                            Image(systemName: "flame")
                            
                        }
                       
                        .roundButton()
                        
                    
                    }
            
            
                    .disabled(vm.image == nil || vm.alreadyChecked || vm.isChecking)
                    .onChange(of: vm.image) { _ in
                        vm.alreadyChecked = false
                    }
                    .onChange(of: vm.currentFilter, perform: { _ in
                        vm.alreadyChecked = false
                    })
                    .onChange(of: vm.filterIntensity, perform: { _ in
                        vm.alreadyChecked = false
                    })
//                    .onChange(of: vm.compliment) { newValue in
//                        guard let image = vm.processedImage else {return}
//                        vm.addMyImage(newValue, image: image)
//                    }
                    
                    
                    Spacer()
                    Button {
                        vm.showingImagePicker = true
                    } label: {
                        VStack {
                            Text("Galery")
                            Image(systemName: "square.grid.2x2")
                        }
                        .roundButton()
                       
                    }
                    .disabled(vm.isChecking)
                    
                }
                HStack {
                    Slider(value: $vm.filterIntensity)
                        .accentColor(.mildPurple)
                        .onChange(of: vm.filterIntensity) { _ in vm.applyProcessing() }
                        .disabled(vm.isChecking)
                    Button("Filter") {
                        vm.showingFilterSheet = true
                    }
                        .roundButton()
                        .disabled(vm.isChecking)
                }
                
                .padding(.vertical)

            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Make a check")
            .onChange(of: vm.inputImage) { _ in vm.loadImage() }
            .sheet(isPresented: $vm.showingImagePicker) {
                ImagePicker(image: $vm.inputImage)
            }
            .sheet(isPresented: $vm.showingCamerPicker, content: {
                CameraPicker(selectedImage: $vm.inputImage)
            })
            .confirmationDialog("Select a filter", isPresented: $vm.showingFilterSheet) {
                Button("Crystallize") { vm.setFilter(CIFilter.crystallize()) }
                Button("Edges") { vm.setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { vm.setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { vm.setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { vm.setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { vm.setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { vm.setFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) { }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
        
      
}

struct CheckView_Previews: PreviewProvider {
    static var previews: some View {
        CheckView()
            .environmentObject(CheckViewModel())
    }
}


