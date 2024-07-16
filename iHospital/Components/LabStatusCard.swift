import SwiftUI

struct LabStatusCard: View {
    let pdfName: String
    let onTap: () -> Void
    
    var body: some View {
        ZStack(alignment : .leading) {
            Rectangle()
                .frame(width: 370, height: 150)
                .cornerRadius(15)
                .foregroundColor(Color(.secondarySystemBackground))
            VStack(alignment: .leading, spacing: 5) {
                HStack{
                    Image(systemName: "testtube.2").foregroundColor(.accentColor)
                    Text("Blood Test").font(.system(size: 20)).bold()
                }
                HStack{
                    Image(systemName: "person")
                    .foregroundColor(.accentColor)
                    Text("John Doe")
                }
                HStack{
                    Image(systemName: "calendar")
                        .foregroundColor(.accentColor)
                    Text("15th July,2024")
                }
                HStack{
                    Image(systemName: "clock.arrow.circlepath").foregroundColor(.accentColor)
                    Text("Pending")
                }
            }
            .padding()
            .foregroundColor(Color(.label))
        }
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    LabStatusCard(pdfName: "sample") {}
}
