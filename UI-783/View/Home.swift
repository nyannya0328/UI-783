//
//  Home.swift
//  UI-783
//
//  Created by nyannyan0328 on 2022/11/08.
//

import SwiftUI

struct Home: View {
    @State var offfsetY : CGFloat = 0
    @State var currentIndex : CGFloat = 0
    var body: some View {
        GeometryReader{
            
            let size = $0.size
            
            let cardSize = size.width
            
            LinearGradient(colors: [
                .clear,
                Color("Brown"),
                Color("Brown").opacity(0.9),
                Color("Brown").opacity(0.6),
                Color("Brown").opacity(0.7),
            
            
            ], startPoint: .top, endPoint: .bottom)
            .frame(height: 300)
            .frame( maxHeight: .infinity,alignment: .bottom)
            .ignoresSafeArea()
         
            
           
            VStack(spacing:0){
                
                ForEach(coffees){coffee in
                    
                    CoffeeView(coffee: coffee, size: size)
                    
                    
                }
            }
            .padding(.top,size.height - cardSize)
            .offset(y:offfsetY)
            .offset(y:-currentIndex * cardSize)
            
            
            HeadeeView()
        
        }
        .contentShape(Rectangle())
        .gesture(
        
        
            DragGesture()
                .onChanged({ value in
                    
                    offfsetY = value.translation.height * 0.5
                    
                })
                .onEnded({ value in
                    
                    withAnimation(.easeInOut(duration: 0.3)){
                        
                        let translation = value.translation.height
                        
                        if translation > 0{
                            
                            
                            if currentIndex > 0 && translation > 250{
                                
                                currentIndex -= 1
                            }
                            
                        }
                            else{
                                
                                
                                if currentIndex < CGFloat(coffees.count - 1) && -translation > 250{
                                    
                                    currentIndex += 1
                                }
                                
                                
                            }
                            
                            offfsetY = .zero
                        
                        
                        
                        
                    }
                })
            
        )
        .coordinateSpace(name: "SCROLL")
    }
    @ViewBuilder
    func HeadeeView ()->some View{
        
        VStack{
            HStack{
                
                Button {
                    
                } label: {
                 
                    Image(systemName: "chevron.left")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.black)
                    
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                 
                    Image("Cart")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                     .frame(width: 30,height: 30)
                    
                }
            }
            
            
            GeometryReader{
                
                let size = $0.size
             
                HStack(spacing:0){
                    
                    ForEach(coffees){cof in
                        
                        VStack(alignment: .leading,spacing: 13) {
                            
                            Text(cof.title)
                                .font(.title2)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            
                            Text(cof.price)
                                .font(.title)
                                .foregroundColor(.orange)
                               
                        }
                    }
                    .frame(width: size.width)
                }
                .offset(x:currentIndex * -size.width)
                .animation(.interactiveSpring(response: 1.1,dampingFraction: 0.85,blendDuration: 0.85), value: currentIndex)
                
            }

            
            
        }
        .padding(15)
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CoffeeView : View{
    var coffee : Coffee
    var size : CGSize
    
    var body: some View{
        
        let cardSize = size.width * 1
        
        let maxCardSize = size.width * 3
        
        GeometryReader { proxy in
            
            let _size = proxy.size
            
            let offset = proxy.frame(in: .named("SCROLL")).minY - (size.height - cardSize)
            
            let scale = offset <= 0 ? (offset / maxCardSize) : 0
            
            let reduceScale = 1 + scale
            
            let currentSclae = offset / cardSize
            
            Image(coffee.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: _size.width,height: _size.height)
                .scaleEffect(reduceScale < 0 ? 0.0001 : reduceScale,anchor: .init(x: 0.5, y: 1 - (currentSclae / 2)))
                .scaleEffect(offset > 0 ? 1 + currentSclae : 1,anchor: .top)
                .offset(y:offset > 0 ? currentSclae * 200 : 0)
                .offset(y:currentSclae * -130)
            
            
           
         
            
        }
        .frame(height: cardSize)
    }
}
