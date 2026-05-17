import QtQuick
import QtQuick.Controls

Item {
    id: gamePage

    signal backToMenu()

    // Змінні для часу та очок
    property int timeElapsed: 0
    property int currentScore: 0
    property bool isGameActive: false // блокування кнопок

    function formatTime(seconds) {
        let m = Math.floor(seconds / 60)
        let s = seconds % 60
        return (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s
    }

    Timer {
        id: gameTimer
        interval: 1000
        running: false
        repeat: true
        onTriggered: timeElapsed++
    }

    // Верхня панель (таймер та очки)
    Rectangle {
        id: topBar
        width: parent.width
        height: 60
        color: "#333333"
        anchors.top: parent.top

        Button {
            text: "← Меню"
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            onClicked: backToMenu()
        }

        Row {
            anchors.centerIn: parent
            spacing: 50
            Text { text: "ЧАС: " + formatTime(timeElapsed); color: "white"; font.pointSize: 16 }
            Text { text: "ОЧКИ: " + currentScore; color: "yellow"; font.pointSize: 18; font.bold: true }
        }
    }

    // Чорновик
    Column {
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        Text { text: "ЧОРНОВИК"; font.bold: true; font.pointSize: 14 }
        Rectangle {
            width: 250; height: 350
            border.color: "grey"; radius: 5

            ScrollView {
                anchors.fill: parent
                anchors.margins: 5
                clip: true // Обрізає все, що вилазить

                TextArea {
                    width: parent.width // Обмеження ширини
                    placeholderText: "Записувати біти тут..."

                    // Переносить текс
                    wrapMode: TextEdit.WrapAnywhere

                    font.pointSize: 12
                    background: null
                }
            }
        }
    }

    // QR-code + кнопки керування
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: topBar.bottom
        anchors.topMargin: 20
        spacing: 30

        // QR-code
        Rectangle {
            width: 420; height: 420
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"

            Grid {
                rows: 21; columns: 21
                Repeater {
                    model: gameLogic.gridModel
                    Rectangle {
                        width: 20; height: 20
                        border.color: "lightgrey"
                        color: {
                            if (model.cellColor === 1) return "black";
                            if (model.cellColor === 2) return hintsCheckbox.checked ? "green" : "black";
                            if (model.cellColor === 3) return hintsCheckbox.checked ? "#b7d9b1" : "white";
                            if (model.cellColor === 4) return noiseCheckbox.checked ? "blue" : "black";
                            return "white";
                        }
                    }
                }
            }
        }

        // Кнопки
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            ComboBox {
                id: difficultySelector
                width: 350; height: 40
                model: ["Легко (3-4 літери)", "Нормально (5-6 літер)", "Складно (7-8 літер)"]
            }

            Button {
                text: "ЗАГАДАТИ НОВИЙ QR-КОД"
                width: 350; height: 40
                onClicked: {
                    gameLogic.generateChallenge(difficultySelector.currentIndex)
                    //Скидання інтерфейсу
                    answerInput.text = ""
                    answerInput.enabled = true
                    isGameActive = true
                    // Скидання таймеру
                    timeElapsed = 0
                    currentScore = 0
                    gameTimer.restart()


                }
            }

            ComboBox {
                id: maskSelector
                width: 350; height: 40
                model: [
                    "Без маски", "Квіткові шпалери 000", "Клітинчастий прапор 001",
                    "Ящірки М.С. Ешера 010", "Шлях сокирою 011", "Тюремний одяг 100", "Партії в шахи 101", "Веселка 110", "За ґратами 111"
                ]

                onActivated: gameLogic.processWord("", currentIndex - 1)
            }

            TextField {
                id: answerInput
                placeholderText: "Яке слово зашифровано?"
                width: 350; height: 40
                horizontalAlignment: TextInput.AlignHCenter
                enabled: isGameActive
            }

            Button {
                text: "ПЕРЕВІРИТИ ВІДПОВІДЬ"
                width: 350; height: 40
                enabled: answerInput.text.length > 0 && isGameActive
                onClicked: {
                    if (gameLogic.checkAnswer(answerInput.text)) {
                        gameTimer.stop()
                        isGameActive = false
                        switch(difficultySelector.currentIndex) {
                            case 0: // Легко || 5000 балів мінус 1.6 балів за кожну витрачену секунду
                                currentScore = Math.max(100, 500 - (timeElapsed * 1.6))
                                break;
                            case 1: // Нормально
                                currentScore = Math.max(100, 1000 - (timeElapsed * 3))
                                break;
                            case 2: // Складно
                                currentScore = Math.max(100, 1500 - (timeElapsed * 5))
                                break;
                        }
                        gameLogic.saveWin(difficultySelector.currentIndex, currentScore, timeElapsed)

                        dialogMainText.text = "✅ ПРАВИЛЬНО!"
                        dialogMainText.color = "green"
                        dialogSubText.text = "Слово: " + answerInput.text.toUpperCase() + "\nОтримано очок: " + currentScore
                    }
                    else {
                        let penalty = 0
                        switch(difficultySelector.currentIndex) {
                            case 0: penalty = 50; break;
                            case 1: penalty = 100; break;
                            case 2: penalty = 200; break;
                        }
                        timeElapsed += penalty

                        dialogMainText.text = "❌ НЕВІРНО"
                        dialogMainText.color = "red"
                        dialogSubText.text = "Спробуй ще раз!\n" + "(Штраф + " + penalty + " секунд)"
                    }
                    resultDialog.open()
                }
            }
        }
    }

    // Підсказка + шпаргалка
    Column {
        anchors.right: parent.right
        anchors.rightMargin: 40
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        CheckBox {
            id: noiseCheckbox
            text: "Підсвітка шуму та каркасу"
            checked: false
        }

        CheckBox {
            id: hintsCheckbox
            text: "Підсвітка бітів маски"
            checked: false
        }

        Text {
            text: "ASCII ШПАРГАЛКА"
            font.bold: true; font.pointSize: 14
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            width: 250
            height: 560
            border.color: "grey"; radius: 5

            ListView {
                anchors.fill: parent
                anchors.margins: 10
                clip: true
                model: [
                    "a : 01100001", "b : 01100010", "c : 01100011",
                    "d : 01100100", "e : 01100101", "f : 01100110",
                    "g : 01100111", "h : 01101000", "i : 01101001",
                    "j : 01101010", "k : 01101011", "l : 01101100",
                    "m : 01101101", "n : 01101110", "o : 01101111",
                    "p : 01110000", "q : 01110001", "r : 01110010",
                    "s : 01110011", "t : 01110100", "u : 01110101",
                    "v : 01110110", "w : 01110111", "x : 01111000",
                    "y : 01111001", "z : 01111010", "___ : 0000 (КІНЕЦЬ)"
                ]
                delegate: Text {
                    text: modelData
                    font.pointSize: 13
                    font.family: "Courier New"
                    color: "black"
                    font.weight: Font.Bold
                }
            }
        }
    }

    Dialog {
        id: resultDialog
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 300
        modal: true
        title: "Результат"
        standardButtons: Dialog.Ok

        contentItem: Rectangle {
            implicitHeight: 100
            color: "white"
            Column {
                anchors.centerIn: parent
                spacing: 10
                Text {
                    id: dialogMainText
                    font.bold: true
                    font.pointSize: 16
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    id: dialogSubText
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}