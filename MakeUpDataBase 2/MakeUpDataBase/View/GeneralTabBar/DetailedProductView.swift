import SwiftUI

struct DetailedProductView: View {
    let product: Product
    @State var alert: AlertItem?

    @State private var isDescriptionExpanded = true
    @State private var isHowToUseExpanded = false
    @State private var isBenefitsExpanded = false
    @State private var isIngredientsExpanded = false
    @State private var isSustainabilityExpanded = false

    private let spacing: CGFloat = 16

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: spacing) {
                    VStack(spacing: spacing) {
                        if let imageUrl = product.image_url {
                            ImageLoader(
                                imageURL: imageUrl,
                                width: UIScreen.main.bounds.width - 32,
                                height: 300,
                                alertItem: $alert
                            )
                            .cornerRadius(12)
                            .shadow(radius: 4)
                        } else {
                            Rectangle()
                                .fill(Color(UIColor.systemGray5))
                                .frame(width: UIScreen.main.bounds.width - 32, height: 300)
                                .cornerRadius(12)
                                .overlay(
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.gray)
                                )
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.brand ?? "No brand")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            Text(product.name ?? "No name")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }

                        HStack(spacing: 24) {
                            if let rating = product.rating,
                               let ratingValue = extractFirstNumber(from: rating),
                               !ratingValue.isEmpty {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text(ratingValue)
                                        .fontWeight(.semibold)
                                }
                            }

                            Text(product.price ?? "N/A")
                                .font(.title3)
                                .fontWeight(.semibold)

                            Spacer()

                            if let urlString = product.url, let url = URL(string: urlString) {
                                Link(destination: url) {
                                    HStack {
                                        Text("Visit")
                                        Image(systemName: "arrow.up.right.square")
                                    }
                                    .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                    .padding(.bottom, spacing)

                    Divider().padding(.vertical, 8)

                    if let description = product.description, !description.isEmpty {
                        collapsibleSection(
                            title: "Description",
                            content: description,
                            isExpanded: $isDescriptionExpanded
                        )
                    }

                    if let howToUse = product.how_to_use, !howToUse.isEmpty {
                        collapsibleSection(
                            title: "How To Use",
                            content: howToUse,
                            isExpanded: $isHowToUseExpanded
                        )
                    }

                    if let benefits = product.benefits, !benefits.isEmpty {
                        collapsibleSection(
                            title: "Benefits",
                            content: benefits,
                            isExpanded: $isBenefitsExpanded
                        )
                    }

                    if let ingredients = product.full_ingredient_list, !ingredients.isEmpty {
                        collapsibleSection(
                            title: "Full Ingredients List",
                            content: ingredients,
                            isExpanded: $isIngredientsExpanded
                        )
                    }

                    if !product.sustainability.isEmpty {
                        collapsibleSustainabilitySection(
                            title: "Sustainability",
                            items: product.sustainability,
                            isExpanded: $isSustainabilityExpanded
                        )
                    }

                }
                .padding()
            }

        }
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func collapsibleSection(title: String, content: String, isExpanded: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isExpanded.wrappedValue.toggle()
                }
            }) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Spacer()

                    Image(systemName: isExpanded.wrappedValue ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                        .animation(.easeInOut, value: isExpanded.wrappedValue)
                }
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())

            if isExpanded.wrappedValue {
                Text(content)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }

            Divider()
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .padding(.vertical, 6)
    }

    @ViewBuilder
    private func collapsibleSustainabilitySection(title: String, items: [String], isExpanded: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isExpanded.wrappedValue.toggle()
                }
            }) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Spacer()

                    Image(systemName: isExpanded.wrappedValue ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                        .animation(.easeInOut, value: isExpanded.wrappedValue)
                }
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())

            if isExpanded.wrappedValue {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(items, id: \.self) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 14))

                            Text(item)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.bottom, 12)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            Divider()
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .padding(.vertical, 6)
    }

    func extractFirstNumber(from text: String?) -> String? {
        guard let text = text else { return nil }
        let pattern = #"[\d\.]+"#
        if let range = text.range(of: pattern, options: .regularExpression) {
            return String(text[range])
        }
        return nil
    }
}
