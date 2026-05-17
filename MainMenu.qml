import QtQuick
import QtQuick.Controls

Rectangle {
    id: menuPage
    color: "#f0f0f0"

    signal startGame
    signal openStats()
    signal openTutorial()

    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "QR DECODER"
            font.pointSize: 40; color: "black"; font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            text: "Грати"
            width: 200; height: 60; anchors.horizontalCenter: parent.horizontalCenter
            palette.buttonText: "black"
            onClicked: startGame()
        }

        Button {
            text: "НАВЧАННЯ"
            width: 200; height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: menuPage.openTutorial()
            palette.buttonText: "black"
        }

        Button {
            text: "СТАТИСТИКА"
            width: 200; height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: menuPage.openStats()
            palette.buttonText: "black"
        }

        Button {
            text: "ВИХІД"
            width: 200; height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            palette.buttonText: "black"
            onClicked: Qt.quit()
        }
    }
}
