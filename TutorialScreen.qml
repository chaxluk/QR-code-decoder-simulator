import QtQuick
import QtQuick.Controls

Item {
    id: tutorialPage
    signal backToMenu()

    Rectangle {
        id: topBar
        width: parent.width; height: 60
        color: "#333333"; anchors.top: parent.top
        Button {
            text: "← Меню"; anchors.left: parent.left; anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            onClicked: backToMenu()
        }
        Text {
            text: "НАВЧАННЯ"; color: "white"
            font.pointSize: 20; font.bold: true; anchors.centerIn: parent
        }
    }

    SwipeView {
        id: swipeView
        anchors.top: topBar.bottom; anchors.bottom: pageIndicator.top
        anchors.left: parent.left; anchors.right: parent.right
        currentIndex: 0

        // Слайд 1
        Item {
            id: slide1
            Row {
                anchors.left: parent.left; anchors.top: parent.top
                spacing: 40; anchors.leftMargin: 80; anchors.topMargin: 80
                Column {
                    width: 500; spacing: 20
                    Text { text: "1. Анатомія QR-коду"; font.pointSize: 26; font.bold: true; color: "#2c3e50" }
                    Text {
                        text: "Наш QR-код має розмір 21x21 піксель.\n\n" +
                              "⬛ Чорні та ⬜ Білі пікселі - це наші дані (1 та 0).\n" +
                              "  • 3 великі квадрати по кутах (Пошукові візерунки)\n" +
                              "  • Корисні дані нашого зашифрованого слова.\n\n" +
                              "🟦 Сині пікселі (якщо включити підсвітку) - це службовий каркас:\n" +
                              "  • Пунктирні лінії (Таймінг-патерни)\n" +
                              "  • Лінії формату (дані про маску)\n" +
                              "  • Випадковий шум, який заповнює залишок поля після слова та термінатора."
                        wrapMode: Text.WordWrap; width: parent.width; font.pointSize: 15
                    }
                }
                Image {
                    source: "qrc:/QR_code_conundrum/tuto_1_anatomy.png"; width: 1200; height: 1200
                    fillMode: Image.PreserveAspectFit; horizontalAlignment: Image.AlignLeft; verticalAlignment: Image.AlignTop
                }
            }
        }

        // Слайд 2
        Item {
            Row {
                anchors.left: parent.left; anchors.top: parent.top
                spacing: 40; anchors.leftMargin: 80; anchors.topMargin: 80
                Column {
                    width: 500; spacing: 20
                    Text { text: "2. Маски"; font.pointSize: 26; font.bold: true; color: "#2c3e50" }
                    Text {
                        text: "Щоб сканеру було легше читати код, на нього накладається XOR-маска. Вона перетворює код на «кашу». " +
                              "Щоб зрозуміти, яка маска потрібна, треба подивитися на модуль «Інформація про формат».\n\n" +
                              "Він знаходиться горизонтально під лівим верхнім квадратом, або дублюється вертикально праворуч від лівого нижнього.\n\n" +
                              "Увімкни підсвітку маски, щоб побачити 3 біти:\n" +
                              "  • 🟩 Темно-зелений = 1 (без підсвітки - чорний)\n" +
                              "  • 🟩 Світло-зелений = 0 (без підсвітки - білий)\n\n" +
                              "Читаємо зліва направо або знизу вверх.\n" +
                              "Приклад: 0-0-1 = маска «Клітинчастий прапор 001».\n\n" +
                              "Обери цю маску у випадаючому списку під QR-кодом, і маска зніметься"
                        wrapMode: Text.WordWrap; width: parent.width; font.pointSize: 16
                    }
                }
                Image {
                    source: "qrc:/QR_code_conundrum/tuto_2_masks.png"; width: 1200; height: 1200
                    fillMode: Image.PreserveAspectFit; horizontalAlignment: Image.AlignLeft; verticalAlignment: Image.AlignTop
                }
            }
        }

        // Слайд 3
        Item {
            Row {
                anchors.left: parent.left; anchors.top: parent.top
                spacing: 40; anchors.leftMargin: 80; anchors.topMargin: 80
                Column {
                    width: 500; spacing: 20
                    Text { text: "3. Режим і Довжина"; font.pointSize: 26; font.bold: true; color: "#2c3e50" }
                    Text {
                        text: "Перші біти, які ти прочитаєш (на самому старті внизу праворуч), - це службова інформація.\n\n" +
                              "• Перші 4 біти - це індикатор режиму. В цій грі це умовність, тому завжди 0100 (Байтовий режим).\n" +
                              "• Наступні 8 бітів: довжина слова у двійковій системі.\n\n" +
                              "Наприклад, 00000011 у двійковій системі = 3. Значить, у слові 3 літер."
                        wrapMode: Text.WordWrap; width: parent.width; font.pointSize: 16
                    }
                }
                Image {
                    source: "qrc:/QR_code_conundrum/tuto_3_header.png"; width: 1200; height: 1200
                    fillMode: Image.PreserveAspectFit; horizontalAlignment: Image.AlignLeft; verticalAlignment: Image.AlignTop
                }
            }
        }

        // Слайд 4
        Item {
            Row {
                anchors.left: parent.left; anchors.top: parent.top
                spacing: 40; anchors.leftMargin: 80; anchors.topMargin: 80
                Column {
                    width: 500; spacing: 20
                    Text { text: "4. Читання QR-code"; font.pointSize: 26; font.bold: true; color: "#2c3e50" }
                    Text {
                        text: "Ми читаємо біти колонками по 2 пікселі завширшки:\n\n" +
                              "1️. Починаємо знизу-праворуч.\n" +
                              "2️. Йдемо ЗНИЗУ ВГОРУ (правий-лівий, крок вгору).\n" +
                              "3️. Зверху розвертаємось і йдемо ЗВЕРХУ ВНИЗ.\n\n" +
                              "Службові (сині) клітинки просто перестрибуємо."
                        wrapMode: Text.WordWrap; width: parent.width; font.pointSize: 16
                    }
                }
                Image {
                    source: "qrc:/QR_code_conundrum/tuto_4_snake.png"; width: 1200; height: 1200
                    fillMode: Image.PreserveAspectFit; horizontalAlignment: Image.AlignLeft; verticalAlignment: Image.AlignTop
                }
            }
        }

        // Слайд 5
        Item {
            Row {
                anchors.left: parent.left; anchors.top: parent.top
                spacing: 40; anchors.leftMargin: 80; anchors.topMargin: 80
                Column {
                    width: 500; spacing: 20
                    Text { text: "5. Читання символів"; font.pointSize: 26; font.bold: true; color: "#2c3e50" }
                    Text {
                        text: "Кожні 8 бітів = 1 символ з таблиці ASCII.\n\n" +
                              "1. Бери блоки по 8 бітів.\n" +
                              "2. Шукай код у шпаргалці праворуч від гри.\n" +
                              "3. Слово закінчується термінатором - 4 нулями (0000)\n\n" +
                              "Все інше - це шум, його читати не треба."
                        wrapMode: Text.WordWrap; width: parent.width; font.pointSize: 16
                    }
                }
                Image {
                    source: "qrc:/QR_code_conundrum/tuto_5_chars.png"; width: 1200; height: 1200
                    fillMode: Image.PreserveAspectFit; horizontalAlignment: Image.AlignLeft; verticalAlignment: Image.AlignTop
                }
            }
        }
    }

    PageIndicator {
        id: pageIndicator
        count: swipeView.count; currentIndex: swipeView.currentIndex
        anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 30
        Row {
            anchors.centerIn: parent; spacing: 150
            Button { text: "Попередня"; enabled: swipeView.currentIndex > 0; onClicked: swipeView.currentIndex-- }
            Button {
                text: swipeView.currentIndex === swipeView.count - 1 ? "Зрозуміло!" : "Наступна"
                onClicked: {
                    if (swipeView.currentIndex < swipeView.count - 1) swipeView.currentIndex++
                    else backToMenu()
                }
            }
        }
    }
}
