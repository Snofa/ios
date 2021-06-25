//
//  MainView.swift
//  Balance
//
//  Created by student on 21.06.2021.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            ContentView().tabItem {
                Label("List", systemImage:"list.dash")
            }
            CalendarView().tabItem {
                Label("Calendar", systemImage:"calendar")
            }
            ChartView().tabItem {
                Label("Chart",systemImage:"chart.pie" )
            }
            MapDetail().tabItem {
                Label("Maps",systemImage:"map" )
            }
            BarCodeView().tabItem {
                Label("Scan",systemImage:"qrcode" )
            }
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
