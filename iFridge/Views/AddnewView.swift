//
//  AddnewView.swift
//  iFridge
//
//  Created by 刘群 on 1/25/25.
//

import SwiftUI

struct AddNewView: View {
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @State private var name: String = ""         // State for the name input
    @State private var selectedCategory: String = "Select a Category" // Selected category
    @State private var selectedImage: Image?    // Optional for the picture
    @State private var amount: Double = 0       // State for the amount slider
    @State private var days: Double = 0         // State for the days slider

    // List of categories for the dropdown
    let categories = ["Vegan", "Meat", "Fruits", "Drinks", "Keto"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Input Box
                HStack(alignment: .top) {
                    // Picture on the left side
                    if let selectedImage = selectedImage {
                        selectedImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                            .padding(.trailing, 8)
                    } else {
                        // Placeholder for the image
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 85, height: 85)
                            .cornerRadius(10)
                            .overlay(
                                Text("Add\nPhoto")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            )
                            .onTapGesture {
                                print("Add photo tapped") // Replace with image picker logic
                            }
                            .padding(.trailing, 8)
                    }

                    // Text Fields
                    VStack(alignment: .leading, spacing: 12) {
                        // Name Text Field
                        TextField("Enter Name", text: $name)
                            .padding(10)
                            .cornerRadius(8)

                        // Dropdown for Category
                        Picker("Category", selection: $selectedCategory) {
                            Text("Select a Category").tag("Select a Category")
                            ForEach(categories, id: \.self) { category in
                                Text(category).tag(category)
                            }
                        }
                        .pickerStyle(MenuPickerStyle()) // Makes it a dropdown menu
                        .padding(1)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                .padding()

                // Slider for Amount
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amount: \(Int(amount))") // Display the current value
                        .font(.headline)
                    Slider(value: $amount, in: 0...30, step: 1) // Slider for amount
                        .accentColor(.blue)
                }
                .padding(.horizontal)

                // Slider for Days
                VStack(alignment: .leading, spacing: 8) {
                    Text("Days: \(Int(days))") // Display the current value
                        .font(.headline)
                    Slider(value: $days, in: 0...15, step: 1) // Slider for days
                        .accentColor(.green)
                }
                .padding(.horizontal)

                Spacer() // Pushes the content to the top

                // Confirm Button
                Button(action: {
                    // Dismiss the current view
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Confirm")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .shadow(radius: 4)
                }
                .padding(.bottom, 20) // Padding to position it above the screen bottom
            }
            .navigationTitle("Add Details")
            .background(Color.white.ignoresSafeArea()) // Set the entire page background to white
        }
    }
}

#Preview {
    AddNewView()
}
