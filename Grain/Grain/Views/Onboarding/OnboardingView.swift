import SwiftUI

// MARK: - OnboardingView

struct OnboardingView: View {
    // MARK: SwiftUI Properties

    @State private var currentPage = 0

    // MARK: Properties

    var didTapNextButton: ((Bool) -> Void)?

    private let pages: [OnboardingPage]

    // MARK: Lifecycle

    init(pages: [OnboardingPage], didTapNextButton: ((Bool) -> Void)?) {
        self.pages = pages
        self.didTapNextButton = didTapNextButton
    }

    // MARK: Content Properties

    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(0 ..< pages.count, id: \.self) { index in
                VStack {
                    if let imageName = pages[index].imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    }
                    VStack(alignment: .leading) {
                        Text(pages[index].title)
                            .font(.h2)
                            .foregroundStyle(Color.textWhite)
                        if let description = pages[index].description {
                            Text(description)
                                .font(.text)
                                .foregroundStyle(Color.textWhite)
                        }
                        Button {
                            let isLast = index == pages.count - 1
                            if isLast {
                                didTapNextButton?(true)
                            } else {
                                withAnimation {
                                    currentPage = index + 1
                                }
                                didTapNextButton?(false)
                            }

                        } label: {
                            if index != pages.count - 1 {
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

// MARK: - OnboardingPage

struct OnboardingPage: Hashable {
    // MARK: Properties

    let id = UUID()
    let imageName: String?
    let title: String
    let description: String?

    // MARK: Lifecycle

    init(imageName: String? = nil, title: String, description: String? = nil) {
        self.imageName = imageName
        self.title = title
        self.description = description
    }
}
