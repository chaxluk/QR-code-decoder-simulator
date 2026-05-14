#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "gamecontroller.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<GameController>("GameLogic", 1, 0, "GameController");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/QR_code_conundrum/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);    
    engine.load(url);



    return QCoreApplication::exec();
}
