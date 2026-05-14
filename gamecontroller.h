#ifndef GAMECONTROLLER_H
#define GAMECONTROLLER_H

#include <QObject>
#include <QString>
#include "gridmodel.h"

class GameController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(GridModel* gridModel READ gridModel CONSTANT)
public:
    explicit GameController(QObject *parent = nullptr);
    GridModel* gridModel();

    Q_INVOKABLE void generateChallenge();
    Q_INVOKABLE void processWord(const QString &word, int playerMaskId);
    Q_INVOKABLE bool checkAnswer(const QString &playerAnswer);

private:
    GridModel m_gridModel;
    QString m_secretWord;
    int m_challengeMask = -1;
};

#endif // GAMECONTROLLER_H