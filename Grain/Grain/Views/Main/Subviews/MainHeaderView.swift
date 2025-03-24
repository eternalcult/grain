import SwiftUI

/// Шапка главного экрана. Содержит в себе кнопку меню, логотип приложения и кнопку экспорта
struct MainHeaderView: View {
    // MARK: SwiftUI Properties

    @Environment(MainRouter.self) private var router
    @State private var viewModel: MainViewModel

    // MARK: Lifecycle

    init(with parentViewModel: MainViewModel) {
        viewModel = parentViewModel
    }

    // MARK: Content Properties

    var body: some View {
        ZStack {
            if viewModel.finalImage != nil {
                HStack {
                    Button {
                        router.push(MainRoute.settings)
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .tint(Color.text)
                    }
                    Spacer()
                }
            }
            Image("grain")
                .resizable()
                .frame(width: 50, height: 50)
                .opacity(0.5)
            if viewModel.finalImage != nil {
                HStack {
                    Spacer()
                    Button {
                        viewModel.saveImageToPhotoLibrary()
                    } label: {
                        Text("Export")
                            .font(.h5)
                            .foregroundStyle(Color.text)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .border(Color.text, width: 1)
                    }
                }
            }
        }
    }
}
