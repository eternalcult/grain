import AppCore
import CoreImage
import SwiftData

final class DataStorage {
    // MARK: Static Properties

    static let shared = DataStorage()

    // MARK: Properties

    let onboardingPages: [OnboardingPage] = [
        .init(
            imageName: "Onboarding/onboarding1",
            title: "Welcome to Grain!",
            description: "Start enhancing your photos with easy-to-use tools and intuitive controls. Grain gives you the power to make your photos look exactly the way you envision them."
        ),
        .init(
            imageName: "Onboarding/onboarding2",
            title: "All-in-One Photo Editing",
            description: "From exposure adjustments to creative filters. Grain has everything you need to transform your photos. Enhance, perfect, and personalize every image with just a few taps!"
        ),
        .init(
            imageName: "Onboarding/onboarding3",
            title: "100% Free to Use!",
            description: "No subscriptions, no hidden fees—Grain is completely free. Enjoy full access to all our powerful photo editing tools without any cost!"
        ),
    ]

    private(set) var filtersCategories: [FilterCategory] = [
        .init(title: "Film Emulation", desc: "", filters: [
            .init(
                id: 1,
                title: "Polatroid 600",
                desc: "A nostalgic filter mimicking the soft tones and unique vignetting of vintage Polaroid 600 film.",
                filename: "Polaroid 600"
            ),
            .init(
                id: 2,
                title: "Fujix Astia 100F",
                desc: "Brings out vibrant yet natural colors with smooth tonal transitions, ideal for portraits and landscapes.",
                filename: "Fuji Astia 100F"
            ),
            .init(
                id: 3,
                title: "Fujix Eterna 3513",
                desc: "A cinematic filter with muted tones and high contrast for a dramatic, filmic look.",
                filename: "Fuji Eterna 3513"
            ),
            .init(
                id: 4,
                title: "Fujix Eterna 8563",
                desc: "Designed for a balanced, soft color palette with subtle highlights, perfect for storytelling.",
                filename: "Fuji Eterna 8563"
            ),
            .init(
                id: 5,
                title: "Fujix Provia 100F",
                desc: "Offers rich, vibrant colors and crisp details, ideal for capturing lively scenes.",
                filename: "Fuji Provia 100F"
            ),
            .init(
                id: 6,
                title: "Fujix Sensia 100",
                desc: "A versatile filter with gentle saturation and a warm tint for everyday photography.",
                filename: "Fuji Sensia 100"
            ),
            .init(
                id: 7,
                title: "Fujix Superia Xtra 400",
                desc: "Known for its bold colors and enhanced contrast, perfect for dynamic and high-energy shots.",
                filename: "Fuji Superia Xtra 400"
            ),
            .init(
                id: 8,
                title: "Fujix Vivid 8543",
                desc: "Creates a strikingly vivid color profile with intense saturation, suited for impactful visuals.",
                filename: "Fuji Vivid 8543"
            ),
            .init(
                id: 9,
                title: "Kodex Ektachrome 64",
                desc: "A retro-inspired filter with cool tones and a fine grain for a vintage aesthetic.",
                filename: "Kodak Ektachrome 64"
            ),
            .init(
                id: 10,
                title: "Kodex Professional Portra 400",
                desc: "Delivers soft, natural tones with excellent skin color reproduction, great for portraits.",
                filename: "Kodak Professional Portra 400"
            ),
            .init(
                id: 11,
                title: "Kodex Vision 2383",
                desc: "A cinematic filter with deep shadows and vivid highlights, replicating a classic movie look.",
                filename: "Kodak Vision 2383"
            ),
            .init(
                id: 12,
                title: "LLP Tetrachrome 400",
                desc: "Features a unique color separation effect, creating a vibrant and experimental style.",
                filename: "LPP Tetrachrome 400"
            ),
            .init(
                id: 13,
                title: "Afga Portrait XPS 160",
                desc: "A gentle filter with soft pastel tones, designed to enhance skin tones for portrait work.",
                filename: "Agfa Portrait XPS 160"
            ),
            .init(
                id: 14,
                title: "65mm",
                desc: "Adds a cinematic depth and texture, emulating the look of classic large-format film.",
                filename: "65MM_FILM_01"
            ),
            .init(
                id: 15,
                title: "35mm",
                desc: "A modern film-inspired filter with a balanced grain and rich contrast, ideal for everyday captures.",
                filename: "MODERN_FILM_01"
            ),
        ]),
        .init(title: "Cinema", desc: "", filters: [
            .init(id: 16, title: "Psycho", desc: "'We all go a little mad sometimes.'", filename: "CINECOLOR_PSYCHO"),
            .init(id: 22, title: "Alien", desc: "'In space, no one can hear you scream.'", filename: "CINECOLOR_ALIEN"),
            .init(id: 17, title: "Blade Runner 2049", desc: "'You’ve never seen a miracle.'", filename: "CINECOLOR_BLADE_RUNNER_2049"),
            .init(id: 18, title: "Clockwork Orange", desc: "'What’s it going to be then, eh?'", filename: "CINECOLOR_CLOCKWORK_ORANGE"),
            .init(id: 19, title: "Jaws", desc: "'You’re gonna need a bigger boat.'", filename: "CINECOLOR_JAWS"),
            .init(id: 20, title: "Saving Private Ryan", desc: "'Earn this.'", filename: "CINECOLOR_SAVING_PRIVATE_RYAN"),
            .init(id: 21, title: "Sin Sity", desc: "'The night is hot as hell.'", filename: "CINECOLOR_SIN_CITY"),
            .init(id: 27, title: "Amelie", desc: "'Times are hard for dreamers.'", filename: "Amelie"),
            .init(id: 28, title: "Aviator", desc: "'The way of the future.'", filename: "Aviator"),
            .init(
                id: 29,
                title: "Blade Runner",
                desc: "'All those moments will be lost in time… like tears in rain.'",
                filename: "Blade Runner"
            ),
            .init(id: 35, title: "Drive", desc: "'You give me a time and a place, I give you a five-minute window.'", filename: "Drive"),
            .init(id: 42, title: "Godfather", desc: "'I'm gonna make him an offer he can't refuse.'", filename: "Godfather"),
            .init(id: 43, title: "Grand Budapest", desc: "'Rudeness is merely the expression of fear.'", filename: "Grand Budapest"),
            .init(id: 46, title: "Hannibal", desc: "'I’m having an old friend for dinner.'", filename: "Hannibal"),
            .init(id: 47, title: "Her", desc: "'The past is just a story we tell ourselves.'", filename: "Her"),
            .init(id: 48, title: "Mad Max", desc: "'Oh, what a day! What a lovely day!'", filename: "Mad Max"),
            .init(id: 49, title: "The Matrix", desc: "'There is no spoon.'", filename: "Matrix V1"),
            .init(id: 50, title: "The Matrix Reloaded", desc: "'I know kung fu.'", filename: "Matrix V2"),
            .init(
                id: 52,
                title: "Moonrise Kingdom",
                desc: "'I love you, but you don’t know what you’re talking about.'",
                filename: "Moonrise Kingdom"
            ),
            .init(id: 59, title: "Stranger Things", desc: "'Friends don’t lie.'", filename: "Stranger Things"),
            .init(id: 64, title: "Wonder Woman", desc: "'It’s about what you believe.'", filename: "Wonder Woman"),
            .init(id: 55, title: "Revenant", desc: "'As long as you can still grab a breath, you fight.'", filename: "Revenant"),
            .init(id: 38, title: "Enemy", desc: "'Chaos is order yet undeciphered.'", filename: "Enemy"),
            .init(id: 57, title: "Seven", desc: "'What’s in the box?!'", filename: "Seven"),
        ]),
    ]

    let texturesCategories: [TextureCategory] = [
        .init(title: "Grain & Dust", textures: [
            .init(title: "Grain & Dust 1", filename: "Textures/GrainDust/01"),
            .init(title: "Grain & Dust 2", filename: "Textures/GrainDust/02"),
            .init(title: "Grain & Dust 3", filename: "Textures/GrainDust/03"),
            .init(title: "Grain & Dust 4", filename: "Textures/GrainDust/04"),
            .init(title: "Grain & Dust 5", filename: "Textures/GrainDust/05"),
            .init(title: "Grain & Dust 6", filename: "Textures/GrainDust/06"),
            .init(title: "Grain & Dust 7", filename: "Textures/GrainDust/07"),
            .init(title: "Grain & Dust 8", filename: "Textures/GrainDust/08"),
            .init(title: "Grain & Dust 9", filename: "Textures/GrainDust/09"),
            .init(title: "Grain & Dust 10", filename: "Textures/GrainDust/10"),
            .init(title: "Grain & Dust 11", filename: "Textures/GrainDust/11"),
            .init(title: "Grain & Dust 12", filename: "Textures/GrainDust/12"),
            .init(title: "Grain & Dust 13", filename: "Textures/GrainDust/13"),
            .init(title: "Grain & Dust 14", filename: "Textures/GrainDust/14"),
            .init(title: "Grain & Dust 15", filename: "Textures/GrainDust/15"),
            .init(title: "Grain & Dust 16", filename: "Textures/GrainDust/16"),
            .init(title: "Grain & Dust 17", filename: "Textures/GrainDust/17"),
            .init(title: "Grain & Dust 18", filename: "Textures/GrainDust/18"),
            .init(title: "Grain & Dust 19", filename: "Textures/GrainDust/19"),
            .init(title: "Grain & Dust 20", filename: "Textures/GrainDust/20"),
        ]),
        .init(title: "VHS", textures: [
            .init(title: "VHS 1", filename: "Textures/VHS/1"),
            .init(title: "VHS 2", filename: "Textures/VHS/2"),
            .init(title: "VHS 3", filename: "Textures/VHS/3"),
            .init(title: "VHS 4", filename: "Textures/VHS/4"),
            .init(title: "VHS 5", filename: "Textures/VHS/5"),
            .init(title: "VHS 6", filename: "Textures/VHS/6"),
            .init(title: "VHS 7", filename: "Textures/VHS/7"),
            .init(title: "VHS 8", filename: "Textures/VHS/8"),
            .init(title: "VHS 9", filename: "Textures/VHS/9"),
            .init(title: "VHS 10", filename: "Textures/VHS/10"),
            .init(title: "VHS 11", filename: "Textures/VHS/11"),
            .init(title: "VHS 12", filename: "Textures/VHS/v12"),
            .init(title: "VHS 13", filename: "Textures/VHS/v13"),
            .init(title: "VHS 14", filename: "Textures/VHS/v14"),
            .init(title: "VHS 15", filename: "Textures/VHS/v15"),
            .init(title: "VHS 16", filename: "Textures/VHS/v16"),
            .init(title: "VHS 17", filename: "Textures/VHS/v17"),
            .init(title: "VHS 18", filename: "Textures/VHS/v18"),
            .init(title: "VHS 19", filename: "Textures/VHS/v19"),
            .init(title: "VHS 20", filename: "Textures/VHS/v20"),
        ]),
        .init(title: "Holographic", textures: [
            .init(title: "Holographic 1", filename: "Textures/Holographic/1"),
            .init(title: "Holographic 2", filename: "Textures/Holographic/2"),
            .init(title: "Holographic 3", filename: "Textures/Holographic/3"),
            .init(title: "Holographic 4", filename: "Textures/Holographic/4"),
            .init(title: "Holographic 5", filename: "Textures/Holographic/5"),
            .init(title: "Holographic 6", filename: "Textures/Holographic/6"),
            .init(title: "Holographic 7", filename: "Textures/Holographic/7"),
            .init(title: "Holographic 8", filename: "Textures/Holographic/8"),
            .init(title: "Holographic 9", filename: "Textures/Holographic/9"),
            .init(title: "Holographic 10", filename: "Textures/Holographic/10"),
            .init(title: "Holographic 11", filename: "Textures/Holographic/11"),
            .init(title: "Holographic 12", filename: "Textures/Holographic/12"),
            .init(title: "Holographic 13", filename: "Textures/Holographic/13"),
            .init(title: "Holographic 14", filename: "Textures/Holographic/14"),
            .init(title: "Holographic 15", filename: "Textures/Holographic/15"),
            .init(title: "Holographic 16", filename: "Textures/Holographic/16"),
            .init(title: "Holographic 17", filename: "Textures/Holographic/17"),
            .init(title: "Holographic 18", filename: "Textures/Holographic/18"),
            .init(title: "Holographic 19", filename: "Textures/Holographic/19"),
            .init(title: "Holographic 20", filename: "Textures/Holographic/20"),
        ])
    ]

    private let lutsManager = LutsService()

    private var swiftDataManager: SwiftDataManager?

    // MARK: Computed Properties

    var filtersData: [FilterCICubeData] {
        swiftDataManager?.fetch(FilterCICubeData.self) ?? []
    }

    // MARK: Lifecycle

    private init() {
        print("Filters count:", filtersCategories.flatMap(\.filters).count)
        print("Textures count:", texturesCategories.flatMap(\.textures).count)
    }

    // MARK: Functions

    func addSwiftDataContext(_ context: ModelContext) {
        swiftDataManager = SwiftDataManager(context: context)
    }

    func configureFiltersDataIfNeeded() {
        let filtersData = filtersData
        for category in filtersCategories {
            for filter in category.filters {
                if !filtersData.contains(where: { $0.id == filter.id }) {
                    print("\(filter.title) doesn't exist in SwiftData. Trying to create filter data")
                    if let filterData = try? lutsManager.createDataForCIColorCube(for: filter) {
                        print("Add filter data for \(filter.title)")
                        swiftDataManager?.insert(filterData)
                    }
                }
            }
        }
        swiftDataManager?.saveChanges()
    }

    func updateFiltersPreviews(with image: CIImage) async {
        filtersCategories = filtersCategories.map { category in
            print("Processing category: \(category.title)")
            let updatedFilters = category.filters.map { filter in
                print("Processing generate filter preview: \(filter.title)")
                return Filter(
                    id: filter.id,
                    title: filter.title,
                    desc: filter.desc,
                    filename: filter.filename,
                    preview: Task.isCancelled ? nil : try? lutsManager.apply(filter, for: image.downsample(scaleFactor: 0.5))
                )
            }
            return FilterCategory(title: category.title, desc: category.desc, filters: updatedFilters)
        }
    }
}

/*
 1.    3Strip: Inspired by the Technicolor three-strip process used in classic films from the 1930s to 1950s.
 2.    70s: Likely inspired by the general aesthetic of films from the 1970s, known for warm tones and naturalistic color palettes.
 3.    Bleach: Possibly a reference to the “bleach bypass” technique used in films like Saving Private Ryan for desaturated, high-contrast visuals.
 4.    Brooklyn: More likely inspired by a regional or urban aesthetic rather than a specific film, but could reference indie films set in Brooklyn.
 5.    Celadon: This filter name suggests a soft, pastel-like palette, which might not directly reference a specific film.
 6.    Chamoisee: A unique earthy color tone, not clearly tied to a film but may evoke vintage or historical styles.
 7.    Cubanismo: Suggests a vibrant, tropical color palette possibly inspired by Cuban cinema or films set in Cuba.
 8.    Duotone: Could reference a visual style used in modern graphic films, but not specific to one film.
 9.    Emulsion: A nod to analog film stock and its characteristic look, referencing the general feel of celluloid film.
 10.    Enemy: Likely inspired by the Denis Villeneuve film Enemy, known for its distinctive yellow-green tint.
 11.    Enhance: Not directly tied to a film, likely a general filter for improving image clarity and vibrancy.
 12.    Fashion: Could be inspired by high-fashion photo shoots, not tied to a specific movie.
 13.    Glacier: Might reflect the cold, blue tones often seen in films set in icy or remote environments.
 14.    Grime: Suggests a gritty, urban aesthetic, potentially referencing films with a dark or raw atmosphere.
 15.    Grit: Similar to “Grime,” it evokes rugged or harsh visuals, possibly inspired by neo-noir or crime dramas.
 16.    Mint: Suggests a soft, pastel green aesthetic, unlikely to be tied to a specific film.
 17.    Ochre: Earthy tones, not directly tied to a film, but it could evoke desert or period settings.
 18.    Punch: A vibrant, high-contrast filter; may not reference a specific film but a general dynamic style.
 19.    Rhythm: May suggest musical or vibrant cinematic styles but isn’t directly tied to a specific film.
 20.    Seven: Clearly inspired by the David Fincher film Se7en, known for its dark, moody, and desaturated tones.
 21.    Spy: Likely inspired by the spy genre, with cold, metallic, or cinematic tones seen in films like James Bond or Tinker Tailor Soldier Spy.
 22.    Summer: Evoking bright, warm tones; not tied to a specific movie but a seasonal aesthetic.
 23.    Teal and Orange: This directly references the popular cinematic color grading style seen in blockbusters for contrast and vibrancy.
 24.    Thriller: Likely inspired by the general thriller genre, with dark and moody tones.
 25.    Vinteo: Possibly referencing vintage film aesthetics but not tied to a specific movie.
 */
