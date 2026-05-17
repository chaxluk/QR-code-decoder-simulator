import QtQuick
import QtQuick.Controls

Item {
    id:statsPage

    signal backToMenu()
    // Функція для форматування часу
    function formatTime(s) {
        if (s === 0) return "--:--"
        let m = Math.floor(s / 60)
        let sec = s % 60
        return (m < 10 ? "0" : "") + m + ":" + (sec < 10 ? "0" : "") + sec
    }
    //Данні оновлюється при вході в статистику
    StackView.onActivated: {
        updateStats()
    }

    //Заголовок
    Text {
        text: "ТВОЯ СТАТИСТИКА"
        font.pointSize: 30; font.bold: true
        anchors.top: parent.top; anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }

    function updateStats() {
        // Легко
        easyBlock.vGames = gameLogic.getGamesWon(0)
        easyBlock.vScore = gameLogic.getBestScore(0)
        easyBlock.vTime  = formatTime(gameLogic.getBestTime(0))
        easyBlock.vTotal = gameLogic.getTotalScore(0)

        // Нормально
        normalBlock.vGames = gameLogic.getGamesWon(1)
        normalBlock.vScore = gameLogic.getBestScore(1)
        normalBlock.vTime  = formatTime(gameLogic.getBestTime(1))
        normalBlock.vTotal = gameLogic.getTotalScore(1)

        // Складно
        hardBlock.vGames = gameLogic.getGamesWon(2)
        hardBlock.vScore = gameLogic.getBestScore(2)
        hardBlock.vTime  = formatTime(gameLogic.getBestTime(2))
        hardBlock.vTotal = gameLogic.getTotalScore(2)
    }

    Column {
        anchors.centerIn: parent
        spacing: 40
        // Легко
        StatBlock {
            id: easyBlock
            title: "ЛЕГКИЙ РІВЕНЬ"; borderColor: "#27ae60"
        }

        StatBlock {
            id: normalBlock
            title: "НОРМАЛЬНИЙ РІВЕНЬ"; borderColor: "#f39c12"
        }

        StatBlock {
            id: hardBlock
            title: "СКЛАДНИЙ РІВЕНЬ"; borderColor: "#e74c3c"
        }

        Button {
            text: "ОЧИСТИТИ СТАТИСТИКУ"
            width: 250; height: 50
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                gameLogic.resetStats()
            }
        }
    }

    component StatBlock : Rectangle {
        property string title: ""
        property color borderColor: "grey"

        property string vGames: "0"
        property string vScore: "0"
        property string vTime: "--:--"
        property string vTotal: "0"

        width: 650; height: 140; radius: 12
        color: "#ffffff"; border.color: borderColor; border.width: 2

        Text {
            text: title; font.bold: true; font.pointSize: 14; color: borderColor
            anchors.top: parent.top; anchors.left: parent.left; anchors.margins: 12
        }

        Row {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 10
            spacing: 50

            // Перша пара колонок
            Row {
                spacing: 10
                Column { spacing: 8; Text { text: "Ігор:" } Text { text: "Рекорд (очки):" } }
                Column { spacing: 8
                    Text { text: vGames; font.bold: true }
                    Text { text: vScore; font.bold: true; color: "#27ae60" }
                }
            }

            // Друга пара колонок
            Row {
                spacing: 10
                Column { spacing: 8; Text { text: "Рекорд (час):" } Text { text: "Загальний рахунок:" } }
                Column { spacing: 8
                    Text { text: vTime; font.bold: true }
                    Text { text: vTotal; font.bold: true; color: "#2980b9" }
                }
            }
        }
    }

    Button {
        text: "← Меню"
        width: 100; height: 50
        anchors.left: parent.left; anchors.top: parent.top
        anchors.margins: 20; onClicked: backToMenu()
    }
}
