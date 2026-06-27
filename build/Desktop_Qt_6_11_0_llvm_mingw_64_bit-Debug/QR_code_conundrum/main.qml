import QtQuick
import GameLogic 1.0
import QtQuick.Controls

Window {
    id: root
    visible: true
    visibility: Window.Maximized
    title: "QR Decoder"

    minimumWidth: 1280
    minimumHeight: 720

    GameController {
        id:gameLogic
    }

    //Перемикання сторінок
    StackView {
        id: stack
        anchors.fill: parent
        initialItem: mainMenuComponent //Головне меню
    }
    Component {
        id: mainMenuComponent
        MainMenu {
            onStartGame: stack.push(gameScreenComponent)
            onOpenStats: stack.push(statsScreenComponent)
            onOpenTutorial: stack.push(tutorialScreenComponent)
        }
    }
    Component {
        id: gameScreenComponent
        GameScreen  {
            onBackToMenu: stack.pop()
        }
    }
    Component {
        id: statsScreenComponent
        StatsScreen {
            onBackToMenu: stack.pop()
        }
    }
    Component {
        id: tutorialScreenComponent
        TutorialScreen {
            onBackToMenu: stack.pop()
        }
    }
}