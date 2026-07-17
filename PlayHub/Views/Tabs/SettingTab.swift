//
//  SettingsTab.swift
//  PlayHub
//

import SwiftUI
import MapKit


struct SettingsTab: View {

    @ObservedObject private var storage = GameStorage.shared

    @State private var notifications = false
    @State private var reminder = Date()
    @State private var showAlert = false


    var lastSession: GameSession? {

        storage.sessions
            .sorted {
                $0.timestamp > $1.timestamp
            }
            .first
    }


    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 20) {


                    // MARK: Player Profile

                    VStack(alignment: .leading, spacing: 15) {


                        HStack {

                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(.blue)


                            VStack(alignment: .leading) {

                                Text("Player Profile")
                                    .font(.title2)
                                    .bold()


                                Text("PlayHub Gamer")
                                    .foregroundStyle(.secondary)

                            }

                        }


                        Divider()



                        if let session = lastSession {


                            HStack {

                                Image(systemName: "gamecontroller.fill")
                                    .foregroundStyle(.blue)


                                VStack(alignment: .leading) {


                                    Text(session.mode.rawValue)
                                        .font(.headline)


                                    Text("Score: \(session.score)")
                                        .foregroundStyle(.secondary)

                                }

                            }



                            HStack {

                                Image(systemName: "clock.fill")
                                    .foregroundStyle(.orange)


                                Text(
                                    session.timestamp.formatted(
                                        date: .abbreviated,
                                        time: .shortened
                                    )
                                )
                                .foregroundStyle(.secondary)

                            }



                        } else {


                            Text("No games played yet")
                                .foregroundStyle(.secondary)

                        }


                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )





                    // MARK: Location


                    VStack(alignment: .leading, spacing: 15) {


                        Label(
                            "Last Played Location",
                            systemImage: "location.fill"
                        )
                        .font(.headline)



                        if let session = lastSession {


                            Map {


                                Marker(
                                    "Played Here",
                                    coordinate:
                                        CLLocationCoordinate2D(
                                            latitude: session.latitude,
                                            longitude: session.longitude
                                        )
                                )


                            }
                            .frame(height: 220)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 18
                                )
                            )



                            Text(
                                "Latitude: \(session.latitude)"
                            )
                            .font(.caption)



                            Text(
                                "Longitude: \(session.longitude)"
                            )
                            .font(.caption)



                        }
                        else {


                            Text("No location available")
                                .foregroundStyle(.secondary)


                        }


                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )






                    // MARK: Notifications


                    VStack(alignment: .leading, spacing: 15) {


                        Label(
                            "Notifications",
                            systemImage: "bell.fill"
                        )
                        .font(.headline)



                        Toggle(
                            "Daily Reminder",
                            isOn: $notifications
                        )
                        .onChange(of: notifications) {


                            if notifications {


                                NotificationService.shared
                                    .requestPermission()


                            }
                            else {


                                UNUserNotificationCenter
                                    .current()
                                    .removeAllPendingNotificationRequests()

                            }

                        }



                        DatePicker(
                            "Reminder Time",
                            selection: $reminder,
                            displayedComponents: .hourAndMinute
                        )


                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )






                    // MARK: Reset Button


                    Button {


                        showAlert = true


                    } label: {


                        Label(
                            "Reset All Statistics",
                            systemImage: "trash.fill"
                        )
                        .frame(maxWidth: .infinity)
                        .padding()

                    }
                    .foregroundStyle(.red)
                    .background(
                        Color.red.opacity(0.12)
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 18
                        )
                    )



                }
                .padding()

            }
            .background(

                LinearGradient(
                    colors: [
                        .blue.opacity(0.15),
                        .purple.opacity(0.10)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            .navigationTitle("Settings")



            // MARK: Center Alert

            .alert(
                "Reset Statistics?",
                isPresented: $showAlert
            ) {


                Button(
                    "Delete All",
                    role: .destructive
                ) {


                    GameStorage.shared.reset()


                    UserDefaults.standard.removeObject(
                        forKey: "quizHighScore"
                    )


                }



                Button(
                    "Cancel",
                    role: .cancel
                ) {}



            } message: {


                Text(
                    "All game scores and saved locations will be deleted."
                )


            }


        }

    }

}



#Preview {

    SettingsTab()

}
