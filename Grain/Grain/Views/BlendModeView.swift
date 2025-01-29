import SwiftUI

struct BlendModeView: View {
    // MARK: SwiftUI Properties

    @Environment(\.dismiss) private var dismiss

    // MARK: Content Properties

    var body: some View {
        ScrollView {
            Text("Blend modes")
                .font(.h1)
                .foregroundStyle(Color.textWhite)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
            VStack(spacing: 16) {
                ForEach(BlendMode.allCases, id: \.self) { blendMode in
                    VStack {
                        Text(blendMode.title)
                            .font(.h4)
                            .foregroundStyle(Color.textWhite)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(blendMode.description)
                            .font(.text)
                            .foregroundStyle(Color.textWhite)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal)
        .background(Color.backgroundBlack)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.backgroundBlack, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.textWhite)
                }
            }
        }
    }
}
