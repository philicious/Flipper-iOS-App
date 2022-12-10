import Core
import SwiftUI

struct CategoryDeletedView: View {
    @EnvironmentObject var archiveService: ArchiveService
    @Environment(\.dismiss) private var dismiss

    @State var selectedItem: ArchiveItem?
    @State var showRestoreSheet = false
    @State var showDeleteSheet = false

    var restoreSheetTitle: String {
        "All deleted keys will be restored and synced with Flipper"
    }

    var deleteSheetTitle: String {
        "All this keys will be deleted.\nThis action cannot be undone."
    }

    var toolbarActionsColor: Color {
        archiveService.items.isEmpty ? .primary.opacity(0.5) : .primary
    }

    var body: some View {
        ZStack {
            Text("No deleted keys")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black40)
                .opacity(archiveService.items.isEmpty ? 1 : 0)

            ScrollView {
                CategoryList(items: archiveService.deleted) { item in
                    selectedItem = item
                }
                .padding(14)
            }
        }

        .background(Color.background)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            LeadingToolbarItems {
                BackButton {
                    dismiss()
                }
                Title("Deleted")
            }
            TrailingToolbarItems {
                HStack(spacing: 8) {
                    NavBarButton {
                        showRestoreSheet = true
                    } label: {
                        Text("Restore All")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(toolbarActionsColor)
                    }
                    .disabled(archiveService.items.isEmpty)
                    .actionSheet(isPresented: $showRestoreSheet) {
                        .init(title: Text(restoreSheetTitle), buttons: [
                            .destructive(Text("Restore All")) {
                                archiveService.restoreAll()
                            },
                            .cancel()
                        ])
                    }

                    NavBarButton {
                        showDeleteSheet = true
                    } label: {
                        Text("Delete All")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(toolbarActionsColor)
                    }
                    .disabled(archiveService.items.isEmpty)
                    .actionSheet(isPresented: $showDeleteSheet) {
                        .init(title: Text(deleteSheetTitle), buttons: [
                            .destructive(Text("Delete All")) {
                                archiveService.deleteAll()
                            },
                            .cancel()
                        ])
                    }
                }
            }
        }
        .sheet(item: $selectedItem) { item in
            DeletedInfoView(item: item)
        }
    }
}
