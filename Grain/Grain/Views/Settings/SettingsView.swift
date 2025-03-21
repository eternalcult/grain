import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {

    private let viewModel = SettingsViewModel()

    // MARK: SwiftUI Properties

    @Environment(\.dismiss) private var dismiss

    // MARK: Content Properties

    var body: some View {
        List {
            Section {
                Button {
                    AppService.openAppSettings()
                } label: {
                    HStack {
                        Image(systemName: "globe.central.south.asia")
                            .foregroundStyle(Color.text)
                        Text("Switch Language")
                            .font(.h5)
                            .foregroundStyle(Color.text)
                    }
                }

            } header: {
                Text("System Settings")
                    .font(.h6)
            }
            Section {
//                Button {
//                    // TODO: Send feedback button
//                } label: {
//                    VStack(alignment: .leading, spacing: 4) {
//                        HStack {
//                            Image(systemName: "envelope")
//                                .foregroundStyle(Color.text)
//                            Text("Feedback", bundle: .module)
//                                .font(.h5)
//                                .foregroundStyle(Color.text)
//                        }
//                        Text(
//                            "If you have any suggestions, ideas, or questions, feel free to email me directly!",
//                            bundle: .module
//                        )
//                        .font(.textSub)
//                        .foregroundStyle(Color.text)
//                    }
//                }
                Button {
                    AppService.askReviewWithComment()
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "medal.star")
                                .foregroundStyle(Color.text)
                            Text("Rate this app in Appstore")
                                .font(.h5)
                                .foregroundStyle(Color.text)
                        }
                        Text(
                            "If you find the app useful, please leave a review on the App Store. Your support helps improve it. Thank you!"
                        )
                        .font(.textSub)
                        .foregroundStyle(Color.text)
                    }
                }

                Button {
                    AppService.shareAppLink()
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .tint(.text)
                        Text("Share")
                            .font(.h5)
                            .foregroundStyle(Color.text)
                    }
                }

            } header: {
                Text("Common Settings")
                    .font(.h6)
            }
            Section {
                ForEach(viewModel.otherApps) { app in
                    Button {
                        AppService.openAppStore()
                    } label: {
                        HStack {
                            Image(app.iconName)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 50, maxHeight: 50)
                                .clipShape(.rect(cornerRadius: 4))

                            VStack(alignment: .leading, spacing: 4) {
                                Text(app.title)
                                    .font(.h3)
                                    .foregroundStyle(Color.text)
                                Text(app.description)
                                    .font(.textSub)
                                    .foregroundStyle(Color.text)

                            }.padding(.vertical, 4)
                        }
                    }
                }
            } header: {
                Text("Check out my other apps!")
                    .font(.h6)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .foregroundColor(.text)
                        .frame(width: 30, height: 30)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
