import SwiftUI

// MARK: - OnboardingView

struct OnboardingView: View {
    // MARK: SwiftUI Properties

    @State private var currentPage = 0

    // MARK: Properties

    var didTapNextButton: ((Bool) -> Void)?

    private let viewModel = OnboardingViewModel()

    // MARK: Lifecycle

    init(didTapNextButton: ((Bool) -> Void)?) {
        self.didTapNextButton = didTapNextButton
    }

    // MARK: Content Properties

    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(0 ..< viewModel.pages.count, id: \.self) { index in
                VStack {
                    if let imageName = viewModel.pages[index].imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    }
                    VStack(alignment: .leading) {
                        Text(viewModel.pages[index].title)
                            .font(.h2)
                            .foregroundStyle(Color.textWhite)
                        if let description = viewModel.pages[index].description {
                            Text(description)
                                .font(.text)
                                .foregroundStyle(Color.textWhite)
                        }
                        Button {
                            let isLast = index == viewModel.pages.count - 1
                            if isLast {
                                didTapNextButton?(true)
                            } else {
                                withAnimation {
                                    currentPage = index + 1
                                }
                                didTapNextButton?(false)
                            }

                        } label: {
                            if index != viewModel.pages.count - 1 {
                                Text("Next".uppercased())
                                    .font(.buttonL)
                                    .frame(maxWidth: .infinity, maxHeight: 50)
                                    .border(Color.textWhite)
                                    .foregroundStyle(Color.textWhite)

                            } else {
                                Text("Let's start!".uppercased())
                                    .font(.buttonL)
                                    .frame(maxWidth: .infinity, maxHeight: 50)
                                    .border(Color.textWhite)
                                    .foregroundStyle(Color.textWhite)
                            }
                        }
                    }
                }
                .padding()
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topTrailing) {
            Button {
                didTapNextButton?(true)
            } label: {
                Image(systemName: "close.fill")
                    .frame(width: 40, height: 40)
                    .tint(.textWhite)
            }
        }
        .background(Color.backgroundBlack)
    }
}
