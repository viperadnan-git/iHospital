//
//  AppointmentButton.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 04/07/24.
//
//
//import SwiftUI
//
//struct AppointmentButton: View {
//    var imageName: String
//    var doctorName: String
//    var specialty: String
//    var appointmentDate: String
//    var appointmentTime: String
//    var action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            HStack {
//                Image(imageName)
//                    .resizable()
//                    .frame(width: 80, height: 80)
//                    .clipShape(Circle())
//                    .padding(.trailing, 15)
//                
//                VStack(alignment: .leading) {
//                    Text(doctorName)
//                        .font(.headline)
//                        .foregroundColor(.black)
//                    Text(specialty)
//                        .foregroundColor(.black)
//                    HStack {
//                        Image(systemName: "calendar")
//                            .foregroundColor(.black)
//                        Text(appointmentDate)
//                            .foregroundColor(.black)
//                    }
//                    HStack {
//                        Image(systemName: "clock")
//                            .foregroundColor(.black)
//                        Text(appointmentTime)
//                            .foregroundColor(.black)
//                    }
//                }
//                Spacer()
//            }
//            .padding()
//            .background(Color.accentColor.opacity(0.3))
//            .cornerRadius(12)
//            .padding(.horizontal)
//        }
//    }
//}
//
//struct AppointmentButton_Previews: PreviewProvider {
//    static var previews: some View {
//        AppointmentButton(
//            imageName: "doctor_image",
//            doctorName: "Dr. Darlene Robertson",
//            specialty: "Dental Specialist",
//            appointmentDate: "Monday, May 12",
//            appointmentTime: "11:00 - 12:00 AM",
//            action: {
//                // Handle action
//            }
//        )
//        .previewLayout(.sizeThatFits)
//        .padding()
//    }
//}


//import SwiftUI
//
//struct AppointmentButton: View {
//    var imageName: String
//    var doctorName: String
//    var specialty: String
//    var experience: String
//    var appointmentDate: String
//    var appointmentTime: String
//    var action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            VStack(alignment: .leading) {
//                HStack {
//                    Image(imageName)
//                        .resizable()
//                        .frame(width: 60, height: 60)
//                        .clipShape(Circle())
//                        .padding(.trailing, 10)
//                    
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Text(doctorName)
//                                .font(.headline)
//                                .foregroundColor(.white)
//                            Spacer()
//                            HStack {
//                                Image(systemName: "briefcase")
//                                    .foregroundColor(.white)
//                                Text(experience)
//                                    .foregroundColor(.white)
//                            }
//                        }
//                        Text(specialty)
//                            .foregroundColor(.white)
//                    }
//                }
//                .padding()
//                .background(Color.blue)
//                .cornerRadius(12)
//                
//                HStack {
//                    HStack {
//                        Image(systemName: "calendar")
//                            .foregroundColor(.white)
//                        Text(appointmentDate)
//                            .foregroundColor(.white)
//                    }
//                    Spacer()
//                    HStack {
//                        Image(systemName: "clock")
//                            .foregroundColor(.white)
//                        Text(appointmentTime)
//                            .foregroundColor(.white)
//                    }
//                }
//                .padding()
//                .background(Color.blue.opacity(0.9))
//                .cornerRadius(12)
//            }
//            .padding(.horizontal)
//        }
//    }
//}
//
//struct AppointmentButton_Previews: PreviewProvider {
//    static var previews: some View {
//        AppointmentButton(
//            imageName: "doctor_image",
//            doctorName: "Dr. Suresh",
//            specialty: "Orthopaedic",
//            experience: "10yrs",
//            appointmentDate: "Tue, 27 JUL",
//            appointmentTime: "11:00 - 11:30",
//            action: {
//                // Handle action
//            }
//        )
//        .previewLayout(.sizeThatFits)
//        .padding()
//    }
//}
import SwiftUI

struct AppointmentButton: View {
    var imageName: String
    var doctorName: String
    var specialty: String
    var experience: String
    var appointmentDate: String
    var appointmentTime: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(imageName)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(doctorName)
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            HStack {
                                Image(systemName: "briefcase")
                                    .foregroundColor(.white)
                                Text(experience)
                                    .foregroundColor(.white)
                            }
                        }
                        Text(specialty)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.blue)
                
                HStack {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.white)
                        Text(appointmentDate)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.white)
                        Text(appointmentTime)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.blue)
            }
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

struct AppointmentButton_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentButton(
            imageName: "doctor_image",
            doctorName: "Dr. Suresh",
            specialty: "Orthopaedic",
            experience: "10yrs",
            appointmentDate: "Tue, 27 JUL",
            appointmentTime: "11:00 - 11:30",
            action: {
                // Handle action
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}


