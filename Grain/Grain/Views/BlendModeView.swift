import SwiftUI

struct BlendModeView: View {
    // MARK: SwiftUI Properties
    @Environment(MainRouter.self) private var router

    // MARK: Content Properties

    var body: some View {
        ScrollView {
            Text("Blend modes")
                .font(.h1)
                .foregroundStyle(Color.text)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
            VStack(spacing: 16) {
                ForEach(BlendMode.allCases, id: \.self) { blendMode in
                    VStack {
                        Text(blendMode.title)
                            .font(.h4)
                            .foregroundStyle(Color.text)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(blendMode.description)
                            .font(.text)
                            .foregroundStyle(Color.text)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal)
        .background(Color.background)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    router.popToRoot()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.text)
                }
            }
        }
    }
}
