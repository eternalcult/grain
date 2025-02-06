import SwiftUI

struct FiltersView: View {
    @Environment(MainRouter.self) private var router
    @State private var viewModel: MainViewModel

    init(with parentViewModel: MainViewModel) {
        self.viewModel = parentViewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                viewModel.showsFilters.toggle()
            } label: {
                HStack {
                    HStack(alignment: .center) {
                        HStack {
                            Text("Filters")
                                .font(.h4)
                                .foregroundStyle(Color.text.opacity(0.8))
                                .padding(.bottom, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if !viewModel.isLoadingFiltersPreviews {
                                Button {
                                    viewModel.applyRandomFilter()
                                } label: {
                                    Image(systemName: "dice")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .tint(.text.opacity(0.8))
                                }
                            }
                        }
                        .padding(.trailing, 8)
                        if !viewModel.isLoadingFiltersPreviews {
                            Button {
                                router.push(MainRoute.gallery(.filters))
                            } label: {
                                Text("Show all")
                                    .font(.h5)
                                    .italic()
                                    .foregroundStyle(Color.text)
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
            if viewModel.showsFilters {
                if viewModel.isLoadingFiltersPreviews {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.text)
                        Spacer()
                    }
                } else {
                    VStack(spacing: 8) {
                        FiltersHListView()
                            .environment(viewModel)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundSecondary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
