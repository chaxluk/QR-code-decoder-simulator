#ifndef GAMECONTROLLER_H
#define GAMECONTROLLER_H

#include <QObject>
#include <QString>
#include "gridmodel.h"
#include <QSettings>

class GameController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(GridModel* gridModel READ gridModel CONSTANT)
public:
    explicit GameController(QObject *parent = nullptr);
    GridModel* gridModel();

    Q_INVOKABLE void generateChallenge(int difficulty);
    Q_INVOKABLE void processWord(const QString &word, int playerMaskId);
    Q_INVOKABLE bool checkAnswer(const QString &playerAnswer);

    Q_INVOKABLE void saveWin(int difficulty, int score, int time);   // Збереження складності, часу, очки
    Q_INVOKABLE int getGamesWon(int difficulty);         // Кількість перемог
    Q_INVOKABLE int getTotalScore(int difficulty);       // Загальні очки
    Q_INVOKABLE int getBestTime(int difficulty);         // Рекорд-час
    Q_INVOKABLE int getBestScore(int difficulty);        // Рекорд-рахунок
    Q_INVOKABLE void resetStats();         // Скинути статистику
private:
    QString loadRandomWord(int difficulty);
    GridModel m_gridModel;
    QString m_secretWord;
    int m_challengeMask = -1;
};

#endif // GAMECONTROLLER_H