import QtQuick
import GameLogic 1.0
import QtQuick.Controls

Window {
    id: root
    visible: true
    visibility: Window.Maximized
    title: "QR Decoder"

    minimumWidth: 640
    minimumHeight: 480

    GameController {
        id:gameLogic
    }

    //Перемикання сторінок
    StackView {
        id: stack
        anchors.fill: parent
        initialItem: mainMenuComponent //Головне меню
    }
    // Компонент головного меню
    Component {
        id: mainMenuComponent
        MainMenu {
            // push додає новий екран поверх поточного
            onStartGame: stack.push(gameScreenComponent)
            onOpenStats: stack.push(statsScreenComponent)
            onOpenTutorial: stack.push(tutorialScreenComponent)
        }
    }
    // Компонент екрану гри
    Component {
        id: gameScreenComponent
        GameScreen  {
            // pop закриває поточний екран і повертає на попередній
            onBackToMenu: stack.pop()
        }
    }
    // Компонент екрану статистики
    Component {
        id: statsScreenComponent
        StatsScreen {
            onBackToMenu: stack.pop()
        }
    }
    // Компонент екрану навчання
    Component {
        id: tutorialScreenComponent
        TutorialScreen {
            onBackToMenu: stack.pop()
        }
    }
}