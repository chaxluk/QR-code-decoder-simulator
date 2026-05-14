#include "gamecontroller.h"
#include <QDebug>
#include <QRandomGenerator>

GameController::GameController(QObject *parent) : QObject(parent) {}

void GameController::generateChallenge() {
    // 1. Розширимо список слів, щоб було цікавіше
    QStringList words = {
        "cat", "dog", "sun", "code", "ball", "tree", "fish", "star", "halo", "fire",
        "moon", "book", "wind", "data", "byte", "king", "blue", "leaf", "cool", "idea"
    };

    // 2. Використовуємо глобальний генератор Qt
    // bounded(n) повертає число від 0 до n-1
    int wordIndex = QRandomGenerator::global()->bounded(words.size());
    m_secretWord = words[wordIndex];

    // 3. Випадкова маска для шифрування (0-7)
    m_challengeMask = QRandomGenerator::global()->bounded(8);

    // Лог у консоль для розробника (щоб ти знав, що розгадувати)
    qDebug() << "Загадано слово:" << m_secretWord << "Маска:" << m_challengeMask;

    processWord(m_secretWord, -1);
}

void GameController::processWord(const QString &word, int playerMaskId) {
    QString actualWord = word.isEmpty() ? m_secretWord : word;
    if (actualWord.isEmpty()) return;

    QString binaryResult = "0100";
    binaryResult += QString("%1").arg(actualWord.length(), 8, 2, QChar('0'));
    QByteArray bytes = actualWord.toUtf8();
    for (char b : bytes) {
        binaryResult += QString("%1").arg((quint8)b, 8, 2, QChar('0'));
    }
    binaryResult += "0000";
    int dataLength = binaryResult.length();

    // 4. Генерація рандомного шуму через QRandomGenerator
    while (binaryResult.length() < 208) {
        // Додаємо випадково "0" або "1"
        binaryResult += QString::number(QRandomGenerator::global()->bounded(2));
    }

    m_gridModel.populateDate(binaryResult, m_challengeMask, playerMaskId, dataLength);
}

bool GameController::checkAnswer(const QString &playerAnswer) {
    QString cleanedAnswer = playerAnswer.trimmed().toLower();
    QString cleanedSecret = m_secretWord.toLower();

    return cleanedAnswer == cleanedSecret;
}

GridModel* GameController::gridModel() { return &m_gridModel; }