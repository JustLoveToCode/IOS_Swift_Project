// import the SwiftUI Here
import SwiftUI

// Create struct RMSettingsView called View
// This is the SwiftUI that take on the Parent View Model Here

struct RMSettingsView: View {
    
    // Creating the viewModel called RMSettingsViewViewModel Here
    let viewModel:RMSettingsViewViewModel
    
    // Create the init() keyword Here
    init(viewModel:RMSettingsViewViewModel){
        self.viewModel = viewModel
    }

    // Creating the View Here
    var body: some View {
        // Using the ScrollView Method here
        // Using the ForEach keyword to loop through
        // Using the SwiftUI to Build Out the View Here
            List(viewModel.cellViewModels){viewModel in
                HStack {
                    if let image = viewModel.image{
                        Image(uiImage:image)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.white)
                            .aspectRatio(contentMode:.fit)
                            .frame(width:30,height:20)
                            .foregroundColor(Color.red)
                            .padding(8)
                        // Applying the Padding on the right side of the Icon
                            .padding(3)
                        // Getting the iconContainerColor Here
                            .background(Color(viewModel.iconContainerColor))
                            .cornerRadius(6)
                    }
                    // Create the Spacing Between the Icon and the Text
                    Text(viewModel.title).padding(.leading, 10)
                    
                    // Adding the Spacer Here
                    Spacer()
                }
                // Create padding at the bottom of 3
                .padding(.bottom,3)
                // Using onTapGesture Here
                .onTapGesture{
                    viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}

// Creating the Preview Here
#Preview {
    // Having the viewModel RMSettingsViewViewModel Here
    RMSettingsView(viewModel: .init(cellViewModels:RMSettingsOption.allCases.compactMap{
        // This return the type:$0 with the
        // RMSettingsCellViewModel Here
        return RMSettingsCellViewModel(type:$0){option in
            
        }
    }))
}
