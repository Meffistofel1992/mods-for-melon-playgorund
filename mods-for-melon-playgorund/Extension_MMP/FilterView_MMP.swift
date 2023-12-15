//
//  FilterView_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 14.12.2023.
//

import SwiftUI

struct FilterView_MMP: View {

    @FetchRequest<CategoriesMO>(fetchRequest: .categories())
    private var categories

    @Binding var selectedCategories: CategoriesMO?
    @Binding var filterIsShowing: Bool
    @Binding var isAppear: Bool

    var body: some View {
        VStack(spacing: 0) {
            Text("Filter")
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.white)
                .overlay(alignment: .trailing) {
                    Button {
                        withAnimation {
                            isAppear = false
                            Task {
                                try? await Task.sleep_MMP(seconds: 0.2)
                                filterIsShowing = false
                            }
                        }
                    } label: {
                        Image(.iconCancel)
                            .resizable()
                            .iosDeviceTypeFrame_mmp(iOSWidth: 17, iOSHeight: 17, iPadWidth: 34, iPadHeight: 34)

                    }
                    .iosDeviceTypeFrame_mmp(iOSWidth: 28, iOSHeight: 28, iPadWidth: 56, iPadHeight: 56)
                    .addRoundedModifier_MMP(radius: 6)
                }
                .iosDeviceTypeFont_mmp(
                    iOS: .init(name: .mitr, style: .medium, size: 20),
                    iPad: .init(name: .mitr, style: .medium, size: 28)
                )
                .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 85, iPadIsAspect: true)
                .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 20, iPadPadding: 40)

            CategoryList_MMP(data: categories, isFitHeight: true) { category in
                LargeButton_MMP(
                    text: category.title ?? "",
                    borderColor: borderColor(type: category),
                    fontStyle: .fontWithName_MMP(.sfProDisplay, style: .bold, size: isIPad ? 24 : 16),
                    backgroundColor: bgColor(type: category),
                    foregroundColor: foregroundColor(type: category),
                    height: isIPad ? 76 : 38,
                    lineWidth: lineWidth(type: category),
                    action: {
                        if selectedCategories != category {
                            selectedCategories = category
                        }
                    }
                )
                .addShadowToRectangle_mmp()
            }
        }
        .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 20, iPadPadding: 40)
        .background(Color.blackMmp)
        .MMP_cornerRadius_MMP(isIPad ? 32 : 20, corners: [.topLeft, .topRight])
        .transition(.move(edge: .bottom))
    }
}

private extension FilterView_MMP {
    func foregroundColor(type: CategoriesMO) -> Color {
        selectedCategories == type ? .blackMmp : .white
    }

    func bgColor(type: CategoriesMO) -> Color {
        selectedCategories == type ? .white : .blackOpacity
    }

    func borderColor(type: CategoriesMO) -> Color {
        selectedCategories == type ? .lightPurple : .cE9E9E9
    }

    func lineWidth(type: CategoriesMO) -> CGFloat {
        selectedCategories == type ? (isIPad ? 6 : 3) : (isIPad ? 2 : 1)
    }
}

#Preview {
    @State var selectedCategory: CategoriesMO?

    return BottomSheetView_MMP(
        isShowing: .constant(true),
        isAppear: .constant(true),
        content: FilterView_MMP(
            selectedCategories: $selectedCategory,
            filterIsShowing: .constant(true),
            isAppear: .constant(true)
        )
        .environment(\.managedObjectContext, CoreDataMockService_MMP.preview)
    )
}
