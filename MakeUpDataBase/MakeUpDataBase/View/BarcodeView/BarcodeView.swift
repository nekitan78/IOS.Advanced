import SwiftUI

struct BarcodeView: View {
    @ObservedObject var barcodeViewModel: BarcodeViewModel
    @State var isShowProduct: Bool = false
    
    init(viewModel: BarcodeViewModel){
        self.barcodeViewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    ScannerView(scannedCode: $barcodeViewModel.scannedBarcode, isScanning: !isShowProduct)
                        .frame(maxWidth: .infinity, maxHeight: 300)
                    Spacer().frame(height: 60)
                    Label("Scanned Barcode", systemImage: "barcode.viewfinder")
                        .font(.title)
                    
                    Text(barcodeViewModel.scannedBarcode.isEmpty ? "Not scanned yet" : barcodeViewModel.scannedBarcode)
                        .bold()
                        .font(.largeTitle)
                        .foregroundStyle(barcodeViewModel.scannedBarcode.isEmpty ? .red : .green)
                        .padding()
                }
                .navigationTitle("Barcode Scanner")
            }
            .onChange(of: barcodeViewModel.scannedBarcode) { _, newValue in
                // Only proceed if the barcode is non-empty
                guard !newValue.isEmpty else { return }
                
                // Reset product and hide popup before fetching new data
                barcodeViewModel.product = nil
                isShowProduct = false
                
                Task {
                    await barcodeViewModel.getProductInfo()
                    
                    // Show the product popup after data is fetched
                    if barcodeViewModel.product != nil {
                        isShowProduct = true
                    }
                }
            }
            .alert(item: $barcodeViewModel.alertMessage){alert in
                Alert(title: alert.title, message: alert.message, dismissButton: alert.dismissButton)
            }
            .disabled(isShowProduct)
            .blur(radius: isShowProduct ? 20 : 0)
            
            if let product = barcodeViewModel.product, isShowProduct {
                ProductPopUpView(isShowProductDetail: $isShowProduct, product: product, router: barcodeViewModel.router)
                    .onDisappear(){
                        barcodeViewModel.scannedBarcode = ""
                    }
            }
            
            if barcodeViewModel.isLoadingImage{
                LoadingView()
            }
        }
    }
}

#Preview {
    BarcodeView(viewModel: BarcodeViewModel(router: BarcodeRouter()))
}
