import SwiftUI

struct ViewModelView: View {
    
    @StateObject var viewModel = Vmodel()
    
    let rows: [GridItem] = [
        GridItem(.fixed(150)),
        GridItem(.fixed(150)),
        GridItem(.fixed(150))
    ]
    
    let columns: [GridItem] = [
        GridItem(.fixed(150))
    ]
    
    let skyBlue = Color(red: 0.4627, green: 0.8392, blue: 1.0)
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [skyBlue, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                HStack(alignment: .top) {
                    LazyHGrid(rows: rows) {
                        ForEach(viewModel.resImage) { imageModel in
                            imageModel.image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 3)
                        }
                    }
                    
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.rightImage.indices, id: \..self) { index in
                            if index < viewModel.rightImage.count {
                                let imageModel2 = viewModel.rightImage[index]
                                imageModel2.image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: (index == 0) ? 310 : 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                            }
                        }
                    }
                }
                
                Button {
                    withAnimation {
                        viewModel.GetAllImage()
                    }
                } label: {
                    Text("Get an Images")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(Color.green)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .padding()
            }
        }
    }
}

#Preview {
    ViewModelView()
}
