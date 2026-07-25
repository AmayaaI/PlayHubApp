//
//  SettingsTab.swift
//  PlayHub
//

import SwiftUI
import MapKit
import UserNotifications

struct SettingsTab: View {
    @ObservedObject private var storage = GameStorage.shared
    @ObservedObject private var playerStore = PlayerStore.shared

    @State private var notifications = false
    @State private var reminder = Date()
    @State private var showAlert = false
    @State private var showPlayerHistoryAlert = false
    @State private var showingPlayers = false
    @State private var showingHowToPlay = false

    private var lastSession: GameSession? {
        storage.sessions
            .filter { $0.playerID == playerStore.selectedPlayerID }
            .sorted { $0.timestamp > $1.timestamp }
            .first
    }

    private var playerName: String {
        playerStore.selectedPlayer?.name ?? "Choose player"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                premiumBackground

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        heading
                        profileCard
                        howToPlayCard
                        activitySection
                        locationSection
                        remindersSection
                        deletePlayerHistoryButton
                        resetButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 22)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showingPlayers) {
                PlayerProfilesView()
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showingHowToPlay) {
                HowToPlayView()
                    .presentationDetents([.large])
            }
            .alert("Delete All App Data?", isPresented: $showAlert) {
                Button("Delete Everything", role: .destructive) {
                    GameStorage.shared.reset()
                    PlayerStore.shared.resetAllPlayers()
                    UserDefaults.standard.removeObject(forKey: "quizHighScore")
                    UserDefaults.standard.removeObject(forKey: "savedLatitude")
                    UserDefaults.standard.removeObject(forKey: "savedLongitude")
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    notifications = false
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This deletes all game history, saved locations, player profiles, high scores, and scheduled reminders. You must add a new player before playing again. It cannot be undone.")
            }
            .alert("Delete \(playerName)'s History?", isPresented: $showPlayerHistoryAlert) {
                Button("Delete History", role: .destructive) {
                    GameStorage.shared.deleteSessions(for: playerStore.selectedPlayerID)
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Only \(playerName)'s game history and saved game locations will be deleted. Other players will not be affected.")
            }
        }
    }

    private var heading: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                Text("PLAYHUB")
                    .font(.caption.weight(.black))
                    .tracking(2)
                    .foregroundStyle(.cyan)
                Text("Settings")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("Fine-tune your play experience.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
            }

            Spacer()

            Image(systemName: "gearshape.fill")
                .font(.title2)
                .foregroundStyle(.white)
                .padding(13)
                .background(.white.opacity(0.13), in: Circle())
                .overlay { Circle().stroke(.white.opacity(0.14), lineWidth: 1) }
        }
    }

    private var profileCard: some View {
        Button { showingPlayers = true } label: {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.cyan, .blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 62, height: 62)
                    Text(initials)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("ACTIVE PLAYER")
                        .font(.caption2.weight(.bold))
                        .tracking(1.2)
                        .foregroundStyle(.white.opacity(0.52))
                    Text(playerName)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                    Text(lastSession == nil ? "Ready for your first game" : "Your progress is saved here")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.62))
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(10)
                    .background(.white.opacity(0.1), in: Circle())
            }
            .padding(16)
            .premiumCard(cornerRadius: 24)
        }
        .buttonStyle(.plain)
    }

    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Recent activity", icon: "sparkles")

            if let session = lastSession {
                HStack(spacing: 12) {
                    Image(systemName: "gamecontroller.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .frame(width: 46, height: 46)
                        .background(LinearGradient(colors: [.pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 15, style: .continuous))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.mode.rawValue)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                        Text(session.timestamp.formatted(date: .abbreviated, time: .shortened))
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.58))
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("SCORE")
                            .font(.caption2.weight(.bold))
                            .tracking(1)
                            .foregroundStyle(.white.opacity(0.48))
                        Text("\(session.score)")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.cyan)
                    }
                }
                .padding(14)
                .premiumCard(cornerRadius: 20)
            } else {
                emptyState("No games played yet", icon: "gamecontroller")
            }
        }
    }

    private var howToPlayCard: some View {
        Button { showingHowToPlay = true } label: {
            HStack(spacing: 14) {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.white)
                    .frame(width: 54, height: 54)
                    .background(LinearGradient(colors: [.mint, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 17, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text("HOW TO PLAY")
                        .font(.caption2.weight(.bold))
                        .tracking(1.2)
                        .foregroundStyle(.white.opacity(0.52))
                    Text("Game guide")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                    Text("Learn the rules before you jump in.")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.62))
                }

                Spacer(minLength: 0)

                Image(systemName: "arrow.right")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white.opacity(0.75))
                    .padding(10)
                    .background(.white.opacity(0.1), in: Circle())
            }
            .padding(14)
            .premiumCard(cornerRadius: 20)
        }
        .buttonStyle(.plain)
    }

    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Last played location", icon: "location.fill")

            if let session = lastSession {
                VStack(spacing: 0) {
                    Map {
                        Marker("Played here", coordinate: CLLocationCoordinate2D(latitude: session.latitude, longitude: session.longitude))
                    }
                    .frame(height: 185)

                    HStack(spacing: 0) {
                        coordinate(title: "LATITUDE", value: String(format: "%.4f", session.latitude))
                        Divider().overlay(.white.opacity(0.16)).frame(height: 30)
                        coordinate(title: "LONGITUDE", value: String(format: "%.4f", session.longitude))
                    }
                    .padding(.vertical, 14)
                    .background(.black.opacity(0.12))
                }
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay { RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(.white.opacity(0.13), lineWidth: 1) }
            } else {
                emptyState("Your next game location will appear here", icon: "map")
            }
        }
    }

    private var remindersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Play reminders", icon: "bell.badge.fill")

            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Daily reminder")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.white)
                        Text("A gentle nudge to keep the streak going")
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.56))
                    }
                    Spacer()
                    Toggle("Daily reminder", isOn: $notifications)
                        .labelsHidden()
                        .tint(.cyan)
                        .onChange(of: notifications) { _, enabled in
                            if enabled {
                                NotificationService.shared.requestPermission()
                            } else {
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            }
                        }
                }
                .padding(16)

                if notifications {
                    Divider().overlay(.white.opacity(0.12))
                    DatePicker("Reminder time", selection: $reminder, displayedComponents: .hourAndMinute)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white)
                        .tint(.cyan)
                        .padding(16)
                }
            }
            .premiumCard(cornerRadius: 20)
        }
    }

    private var resetButton: some View {
        Button(role: .destructive) { showAlert = true } label: {
            Label("Delete all app data", systemImage: "trash.fill")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.red.opacity(0.92))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay { RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(.red.opacity(0.22), lineWidth: 1) }
        }
        .padding(.top, 2)
    }

    private var deletePlayerHistoryButton: some View {
        Button(role: .destructive) { showPlayerHistoryAlert = true } label: {
            HStack(spacing: 12) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.title3)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Delete \(playerName)'s history")
                        .font(.subheadline.weight(.bold))
                    Text("Keeps all player profiles and other players' history")
                        .font(.caption)
                }
                Spacer()
                Image(systemName: "trash")
                    .font(.subheadline.weight(.bold))
            }
            .foregroundStyle(.orange.opacity(0.95))
            .padding(16)
            .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay { RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(.orange.opacity(0.24), lineWidth: 1) }
        }
        .buttonStyle(.plain)
    }

    private var initials: String {
        let parts = playerName.split(separator: " ")
        return parts.prefix(2).compactMap { $0.first }.map(String.init).joined().uppercased()
    }

    private func sectionTitle(_ title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.headline.weight(.bold))
            .foregroundStyle(.white)
    }

    private func coordinate(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(title).font(.caption2.weight(.bold)).tracking(1).foregroundStyle(.white.opacity(0.45))
            Text(value).font(.footnote.weight(.semibold)).foregroundStyle(.white.opacity(0.82))
        }
        .frame(maxWidth: .infinity)
    }

    private func emptyState(_ title: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.cyan)
                .frame(width: 44, height: 44)
                .background(.cyan.opacity(0.12), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
            Spacer()
        }
        .padding(14)
        .premiumCard(cornerRadius: 20)
    }

    private var premiumBackground: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.05, green: 0.06, blue: 0.16), Color(red: 0.16, green: 0.08, blue: 0.34), Color(red: 0.03, green: 0.28, blue: 0.38)], startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle().fill(.purple.opacity(0.38)).frame(width: 300).blur(radius: 55).offset(x: 150, y: -330)
            Circle().fill(.cyan.opacity(0.24)).frame(width: 260).blur(radius: 60).offset(x: -160, y: 300)
        }
        .ignoresSafeArea()
    }
}

private extension View {
    func premiumCard(cornerRadius: CGFloat) -> some View {
        self
            .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(.white.opacity(0.14), lineWidth: 1)
            }
    }
}

#Preview {
    SettingsTab()
}
