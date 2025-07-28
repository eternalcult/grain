import SwiftUI

struct FiltersView: View {
    // MARK: SwiftUI Properties

    @Environment(MainRouter.self) private var router
    @Environment(MainViewModel.self) private var viewModel
    
    // MARK: Content Properties

    var body: some View {
        VStack(alignment: .leading, spacing: .s) {
            Button {
                viewModel.showsFilters.toggle()
            } label: {
                HStack {
                    HStack(alignment: .center) {
                        HStack {
                            Text("Filters")
                                .toggleListHeaderStyle()
                            if !viewModel.isLoadingFiltersPreviews {
                                Button {
                                    viewModel.applyRandomFilter()
                                } label: {
                                    Image(systemName: "dice")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .tint(.text.opacity(0.8))
                                }
                            } else {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.text)
                            }
                        }
                        .padding(.trailing, .s)
                        if !viewModel.isLoadingFiltersPreviews {
                            Button {
                                router.push(MainRoute.gallery(.filters))
                            } label: {
                                Text("Show all")
                                    .showAllButtonStyle()
                            }
                        }
                    }
                    Spacer()
                    Image(systemName: "triangle.fill")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .rotationEffect(viewModel.showsFilters ? Angle(degrees: 180) : Angle(degrees: 0))
                        .tint(.text.opacity(0.8))
                }
            }
            .allowsHitTesting(!viewModel.isLoadingFiltersPreviews)
            if viewModel.showsFilters {
                VStack(spacing: .s) {
                    FiltersHListView()
                        .environment(viewModel)
                }
            }
        }
        .padding(.horizontal, .m)
        .padding(.vertical, 12)
        .background(Color.backgroundSecondary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
