//
//  MainPageView.swift
//  iFridge
//
//  Created by Dennis Austin Jr on 1/25/25.
//

import SwiftUI

struct MainPageView: View {
    @State private var searchText: String = ""
    @State private var selectedCategory: String? = "All" // Auto-select "All" category

    // Sample data for boxes
    var sampleBoxes = ["All", "Vegan", "Meat", "Keto", "Fruits", "Drinks"]

    // Sample data for the vertical list
    @State private var sampleItems = [
        ListItem(title: "Fried Chicken", imageName: "grilled_chicken", description: "Meat", count: 4, days: 3),
        ListItem(title: "Vegan Salad", imageName: "vegan", description: "Vegan", count: 2, days: 7),
        ListItem(title: "Strawberries", imageName: "strawberry", description: "Fruits", count: 5, days: 12),
        ListItem(title: "Steak Dinner", imageName: "steak_dinner", description: "Meat", count: 3, days: 18),
        ListItem(title: "Carrots", imageName: "carrot", description: "Vegan", count: 6, days: 1)
    ]

    // Filtered items based on selected category and search text
    var filteredItems: [ListItem] {
        sampleItems.filter { item in
            (selectedCategory == nil || selectedCategory == "All" || item.description == selectedCategory) &&
            (searchText.isEmpty || item.title.localizedCaseInsensitiveContains(searchText))
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    // Search Bar with Microphone
                    HStack {
                        TextField("Search items...", text: $searchText)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)

                        // Microphone icon on the right
                        Button(action: {
                            print("Microphone tapped")
                        }) {
                            Image(systemName: "mic.fill")
                                .font(.title3)
                                .foregroundColor(.blue)
                                .padding(8)
                        }
                    }
                    .padding(.horizontal)

                    // Horizontal ScrollView (Boxes)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(sampleBoxes, id: \.self) { category in
                                CategoryBox(
                                    title: category,
                                    isSelected: selectedCategory == category
                                )
                                .onTapGesture {
                                    selectedCategory = category // Update selected category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                    .padding(.bottom, 8)

                    // Vertical List (Items)
                    List {
                        ForEach(filteredItems) { item in
                            ListItemView(item: item)
                                .listRowSeparator(.hidden) // Hide the separator line
                        }
                    }
                    .listStyle(PlainListStyle()) // Clean list style

                    Spacer() // Leave space for the fixed button
                }

                // Add New Button
                VStack {
                    Spacer()
                    NavigationLink(destination: AddNewView()) {
                        Text("Add")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .shadow(radius: 4)
                    }
                    .padding(.bottom, 20) // Position near the bottom of the screen
                }
            }
            .navigationTitle("My Fridge")
        }
    }
}

// Model for List Items
struct ListItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let description: String
    let count: Int
    let days: Int
}

// Horizontal Category Box
struct CategoryBox: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .font(.footnote)
            .fontWeight(isSelected ? .bold : .regular)
            .foregroundColor(isSelected ? .white : .gray)
            .padding()
            .background(isSelected ? Color.blue : Color.gray.opacity(12 / 100))
            .cornerRadius(12)
    }
}

// Vertical List Item View
struct ListItemView: View {
    let item: ListItem

    var body: some View {
        HStack {
            // Image on the left from Assets
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .cornerRadius(8)
                .padding(.trailing, 8)

            // Title, description, count, and days
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)

                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                // Count and days side by side
                HStack(spacing: 8) {
                    Text("X\(item.count)")
                        .font(.subheadline)
                        .foregroundColor(.blue)

                    Text("\(item.days) days")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(dayColor(for: item.days))
                        .cornerRadius(8)
                }
            }

            Spacer()

            // Three dots on the far right
            Image(systemName: "ellipsis")
                .foregroundColor(.gray)
                .padding(.leading, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 1)
                .background(Color(.systemGray6).cornerRadius(12))
        )
    }

    // Determine the background color for the day count
    private func dayColor(for days: Int) -> Color {
        if days <= 5 {
            return Color.green
        } else if days <= 14 {
            return Color.yellow
        } else {
            return Color.red
        }
    }
}

#Preview {
    MainPageView()
}
